import UIKit
import RxSwift
import CCBottomRefreshControl

final class CatalogViewController: UIViewController {
    private let viewModel: CatalogPageViewModel
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    private let bottomRefreshControl: UIRefreshControl = {
        let item = UIRefreshControl()
        item.triggerVerticalOffset = 100
        return item
    }()
    private lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 25
        let item = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        item.backgroundColor = .white
        item.translatesAutoresizingMaskIntoConstraints = false
        item.alwaysBounceVertical = true
        item.contentInset = .init(top: flowlayout.minimumLineSpacing, left: 0, bottom: 0, right: 0)
        item.register(ProductInCatalogCell.self, forCellWithReuseIdentifier: ProductInCatalogCell.reuseId)
        item.keyboardDismissMode = .interactive
        return item
    }()
    private let collectionCellHeight: CGFloat = 200
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var indicator: UIActivityIndicatorView = {
        let item = UIActivityIndicatorView(style: .gray)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    init(viewModel: CatalogPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.showsCancelButton = false
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductViewController(viewModel: viewModel.productPageViewModel(for: indexPath.row))
        vc.closeCallback = {[weak self] in
            self?.viewModel.updateProduct(by: indexPath.row)
        }
        show(vc, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var count: CGFloat = 0
        if UIDevice.iPhone && UIDevice.current.orientation.isLandscape {
            count = 2
        }
        else if UIDevice.iPhone && !UIDevice.current.orientation.isLandscape {
            count = 1
        }
        else if !UIDevice.iPhone && UIDevice.current.orientation.isLandscape {
            count = 3
        }
        else if !UIDevice.iPhone && !UIDevice.current.orientation.isLandscape {
            count = 2
        }
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = (collectionView.frame.size.width - flowLayout.sectionInset.left) / count - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing - 1

        return .init(width: width, height: collectionCellHeight)
    }
}

//MARK: - Private
private extension CatalogViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.bottomRefreshControl = bottomRefreshControl
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Я ищу"
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupRx() {
        viewModel.productsDriver.drive(collectionView.rx.items(cellIdentifier: ProductInCatalogCell.reuseId, cellType: ProductInCatalogCell.self)) {[weak self] row, productBasket, cell in
            guard let self = self else { return }
            cell.configure(viewModel: self.viewModel.productViewModel(for: row))
        }
        .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] (_) in
            self?.viewModel.fetchProducts()
        }).disposed(by: disposeBag)
        
        viewModel.isFetchingDriver
        .filter({$0 == false})
        .drive(refreshControl.rx.isRefreshing)
        .disposed(by: disposeBag)
        
        bottomRefreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] (_) in
            self?.viewModel.fetchProducts(withSuplement: true)
        }).disposed(by: disposeBag)
        
        viewModel.isFetchingWithSupplementDriver
            .filter({$0 == false})
            .drive(bottomRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.fetchingErrorDriver.drive(onNext: {[weak self] (error) in
            self?.showErrorAlert(error)
        }).disposed(by: disposeBag)
        
        searchController.searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.filterTitle)
            .disposed(by: disposeBag)
        
        viewModel.isFetchingDriver.asDriver().drive(collectionView.rx.isHidden).disposed(by: disposeBag)
        viewModel.isFetchingDriver.drive(indicator.rx.isAnimating).disposed(by: disposeBag)
    }
}

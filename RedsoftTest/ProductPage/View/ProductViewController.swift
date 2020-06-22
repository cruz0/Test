import UIKit
import RxSwift

final class ProductViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: ProductPageViewModel
    
    private let scrollView: ScrollView = {
        let item = ScrollView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.alwaysBounceVertical = true
        return item
    }()
    
    private lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 17, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.numberOfLines = 0
        return item
    }()
    
    private lazy var producerLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 14, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.numberOfLines = 0
        item.textColor = .systemGray
        return item
    }()
    
    private lazy var imageView: UIImageView = {
        let item = UIImageView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.contentMode = .scaleToFill
        return item
    }()
    
    private lazy var info: ProductInfoView = {
        let item = ProductInfoView()
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    private lazy var priceLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 17, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.textColor = UIColor.fromRGB(rgbValue: 0x4050DD)
        return item
    }()
    
    private lazy var amountButtons: AmountButtons = {
        let item = AmountButtons(basketStyle: .iconWithTitle)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = UIColor.fromRGB(rgbValue: 0x4050DD)
        return item
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let item = UIActivityIndicatorView(style: .gray)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    var closeCallback: (()->())?
    
    init(viewModel: ProductPageViewModel) {
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
        viewModel.fetchProduct()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeCallback?()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

private extension ProductViewController {
    func setupUI(){
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let topStack = UIStackView(arrangedSubviews: [titleLabel, producerLabel])
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.axis = .vertical
        topStack.alignment = .fill
        topStack.distribution = .fillProportionally

        scrollView.contentView.addSubview(topStack)
        let padding: CGFloat = 15
        topStack.leftAnchor.constraint(equalTo: scrollView.contentView.leftAnchor, constant: padding).isActive = true
        topStack.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor, constant: padding).isActive = true
        topStack.rightAnchor.constraint(equalTo: scrollView.contentView.rightAnchor).isActive = true

        scrollView.contentView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: scrollView.contentView.leftAnchor, constant: padding).isActive = true
        imageView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: padding).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        scrollView.contentView.addSubview(info)
        scrollView.contentView.addSubview(priceLabel)
        info.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: padding).isActive = true
        info.rightAnchor.constraint(equalTo: scrollView.contentView.rightAnchor, constant:  -padding).isActive = true
        info.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        info.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor, constant: -40).isActive = true

        priceLabel.leftAnchor.constraint(equalTo: topStack.leftAnchor).isActive = true
        priceLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: padding * 2).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor, constant: -40).isActive = true

        scrollView.contentView.addSubview(amountButtons)
        amountButtons.rightAnchor.constraint(equalTo: scrollView.contentView.rightAnchor, constant: -padding).isActive = true
        amountButtons.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        amountButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupRx() {
        viewModel.productViewModelDriver
            .filter({$0 != nil})
            .drive(onNext: {[weak self] (productViewModel) in
                guard let productViewModel = productViewModel else { return }
                self?.title = productViewModel.title
                self?.titleLabel.text = productViewModel.title
                self?.producerLabel.text = productViewModel.producer
                self?.info.descriptionLabel.text = productViewModel.shortDescription
                self?.priceLabel.text = productViewModel.price
                self?.info.setCategories(productViewModel.categories)
                self?.imageView.kf.setImage(with: productViewModel.imageURL, options: [.fromMemoryCacheOrRefresh])
                self?.amountButtons.amount = productViewModel.countInBasket
                self?.amountButtons.amountChanged = {amount, isNew in
                    productViewModel.amountChanged(amount: amount, isNew: isNew)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isFetchingDriver.asDriver().drive(scrollView.rx.isHidden).disposed(by: disposeBag)
        viewModel.isFetchingDriver.drive(indicator.rx.isAnimating).disposed(by: disposeBag)
        viewModel.fetchingErrorDriver.drive(onNext: {[weak self] (error) in
            self?.scrollView.isHidden = true
            self?.showErrorAlert(error) {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

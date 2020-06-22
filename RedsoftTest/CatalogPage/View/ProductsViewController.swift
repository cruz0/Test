//
//  ViewController.swift
//  RedsoftTest
//
//  Created by Alex on 15.06.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CatalogViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let collectionHeight: CGFloat = 200
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = CatalogViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        viewModel.fetchProducts()
    }
}

//MARK: - UISearchResultsUpdating
extension CatalogViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VC2") as? ProductsDetailedViewController {
            show(vc, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing - 1

        return .init(width: width, height: collectionHeight)
    }
}

//MARK: - Private
private extension CatalogViewController {
    func setupUI() {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = .zero
        flowlayout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 25
        
        collectionView.collectionViewLayout = flowlayout
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = .init(top: flowlayout.minimumLineSpacing, left: 0, bottom: 0, right: 0)
        collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: CatalogCell.reuseId)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Я ищу"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupRx() {
        viewModel.products.asDriver().drive(collectionView.rx.items(cellIdentifier: CatalogCell.reuseId, cellType: CatalogCell.self)) {_, product, cell in
            
        }
        .disposed(by: disposeBag)
    }
}

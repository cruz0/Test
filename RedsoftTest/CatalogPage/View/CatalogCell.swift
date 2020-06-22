//
//  Cell.swift
//  RedsoftTest
//
//  Created by Alex on 15.06.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    static let reuseId = "CatalogCell"
    
    private lazy var imageView: UIImageView = {
        let item = UIImageView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = .systemGray
        return item
    }()
    
    private lazy var detailedInfo: CatalogInfoView = {
        let item = CatalogInfoView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = .systemGray
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.fromRGB(rgbValue: 0xE1E1E1).cgColor
        clipsToBounds = true
        
        let padding: CGFloat = 15
        contentView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        contentView.addSubview(detailedInfo)
        detailedInfo.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: padding).isActive = true
        detailedInfo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -padding).isActive = true
        detailedInfo.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        detailedInfo.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: Product) {
        imageView.kf.setImage(with: URL(string: product.image_url), options: [.fromMemoryCacheOrRefresh])
        detailedInfo.categoryLabel.text = product.categories
    }
}

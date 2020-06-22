import UIKit
import Kingfisher

final class ProductInCatalogCell: UICollectionViewCell {
    static let reuseId = "CatalogCell"
    
    private lazy var imageView: UIImageView = {
        let item = UIImageView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.contentMode = .scaleToFill
        return item
    }()
    
    private lazy var catalogInfo: CatalogInfoView = {
        let item = CatalogInfoView()
        item.translatesAutoresizingMaskIntoConstraints = false
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

        contentView.addSubview(catalogInfo)
        catalogInfo.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: padding).isActive = true
        catalogInfo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -padding).isActive = true
        catalogInfo.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        catalogInfo.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ProductViewModel) {
        imageView.kf.setImage(with: viewModel.imageURL, options: [.fromMemoryCacheOrRefresh])
        catalogInfo.categoryLabel.text = viewModel.firstCategory
        catalogInfo.titleLabel.text = viewModel.title
        catalogInfo.producerLabel.text = viewModel.producer
        catalogInfo.priceLabel.text = viewModel.price
        catalogInfo.priceLabel.layoutIfNeeded()
        catalogInfo.amountButtons.amount = viewModel.countInBasket
        catalogInfo.amountButtons.amountChanged = {amount, isNew in
            viewModel.amountChanged(amount: amount, isNew: isNew)
        }
    }
}

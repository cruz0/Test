import UIKit

final class ProductInfoView: UIView {
    private(set) lazy var descriptionLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 17, weight: .regular)
        item.adjustsFontSizeToFitDevice()
        item.numberOfLines = 0
        return item
    }()
    
    private var categoryLabel: UILabel {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 14, weight: .regular)
        item.adjustsFontSizeToFitDevice()
        item.textColor = .systemGray
        item.numberOfLines = 0
        return item
    }
    private lazy var categoriesStack: UIStackView = {
        let item = UIStackView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.axis = .vertical
        item.alignment = .fill
        item.distribution = .fill
        item.spacing = 8
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        addSubview(categoriesStack)
        categoriesStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        categoriesStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        categoriesStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        categoriesStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCategories(_ categories: [String]) {
        categoriesStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        categories.forEach { (category) in
            let label = categoryLabel
            label.text = category
            categoriesStack.addArrangedSubview(label)
        }
    }
}


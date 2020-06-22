import UIKit

final class CatalogInfoView: UIView {
    private(set) lazy var categoryLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 14, weight: .regular)
        item.adjustsFontSizeToFitDevice()
        item.textColor = .systemGray
        return item
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 17, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.numberOfLines = 1
        return item
    }()
    
    private(set) lazy var producerLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 14, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.numberOfLines = 1
        item.textColor = .systemGray
        return item
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let item = UILabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.font = .systemFont(ofSize: 17, weight: .bold)
        item.adjustsFontSizeToFitDevice()
        item.textColor = UIColor.fromRGB(rgbValue: 0x4050DD)
        return item
    }()
    
    private(set) lazy var amountButtons: AmountButtons = {
        let item = AmountButtons(basketStyle: .icon)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.color = UIColor.fromRGB(rgbValue: 0x4050DD)
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let padding: CGFloat = 4
        addSubview(categoryLabel)
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        
        addSubview(amountButtons)
        amountButtons.leftAnchor.constraint(greaterThanOrEqualTo: priceLabel.rightAnchor, constant: padding).isActive = true
        amountButtons.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        amountButtons.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        amountButtons.heightAnchor.constraint(equalToConstant: 25).isActive = true
        amountButtons.widthAnchor.constraint(greaterThanOrEqualTo: amountButtons.heightAnchor, multiplier: 1).isActive = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, producerLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 12
        addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.topAnchor.constraint(greaterThanOrEqualTo: categoryLabel.bottomAnchor).isActive = true
        stack.bottomAnchor.constraint(lessThanOrEqualTo: priceLabel.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

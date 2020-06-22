import UIKit
import RxSwift

final class AmountButtons: UIStackView {
    enum BasketStyle {
        case icon
        case iconWithTitle
    }
    
    var color: UIColor? {
        didSet {
            minusButton.backgroundColor = color
            plusButton.backgroundColor = color
            amountLabel.backgroundColor = color
            basketButton.backgroundColor = color
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var basketIconButton: UIButton {
        let item = UIButton(type: .custom)
        item.layer.cornerRadius = 4
        item.tintColor = .white
        item.setImage(UIImage(named: "basket"), for: .normal)
        item.imageEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        return item
    }
    private var basketIconWithTitleButton: UIButton {
        let item = UIButton(type: .custom)
        item.layer.cornerRadius = 4
        item.tintColor = .white
        item.setImage(UIImage(named: "basket"), for: .normal)
        item.setTitle("В корзину", for: .normal)
        item.titleLabel?.adjustsFontSizeToFitDevice()
        
        item.semanticContentAttribute = .forceRightToLeft
        item.setInsets(forContentPadding: .init(top: 0, left: 40, bottom: 0, right: 40), imageTitlePadding: -20)
        return item
    }
    private var basketButton: UIButton!
    
    private lazy var minusButton: UIButton = {
        let item = UIButton(type: .custom)
        item.setTitle("-", for: .normal)
        item.titleLabel?.adjustsFontSizeToFitDevice()
        item.clipsToBounds = true
        item.layer.cornerRadius = 4
        item.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return item
    }()
    
    private lazy var plusButton: UIButton = {
        let item = UIButton(type: .custom)
        item.setTitle("+", for: .normal)
        item.titleLabel?.adjustsFontSizeToFitDevice()
        item.clipsToBounds = true
        item.layer.cornerRadius = 4
        item.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return item
    }()
    
    private lazy var amountLabel: UILabel = {
        let item = UILabel()
        item.font = .systemFont(ofSize: 14, weight: .regular)
        item.adjustsFontSizeToFitDevice()
        item.textColor = .white
        item.textAlignment = .center
        return item
    }()
    
    var amountChanged: ((_ amount: Int, _ isNew: Bool) -> Void)?
    
    var amount: Int = 0 {
        didSet {
            setupControls(amountMode: amount > 0)
            amountLabel.text = "\(amount) шт"
        }
    }
    
    init(basketStyle: BasketStyle) {
        super.init(frame: .zero)
        basketButton = basketStyle == .icon ? basketIconButton : basketIconWithTitleButton
        
        setupControls(amountMode: false)
        
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        
        basketButton.rx.tap.subscribe {[weak self] _ in
            guard let self = self else {return}
            self.amount = 1
            self.amountChanged?(self.amount, true)
            self.setupControls(amountMode: true)
        }.disposed(by: disposeBag)
        
        plusButton.rx.tap.subscribe {[weak self] _ in
            guard let self = self else {return}
            self.amount += 1
            self.amountChanged?(self.amount, false)
        }.disposed(by: disposeBag)
        
        minusButton.rx.tap.subscribe {[weak self] _ in
            guard let self = self else {return}
            self.amount -= 1
            self.amountChanged?(self.amount, false)
        }.disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupControls(amountMode: Bool) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        if amountMode {
            addArrangedSubview(minusButton)
            addArrangedSubview(amountLabel)
            addArrangedSubview(plusButton)
        } else {
            addArrangedSubview(basketButton)
        }
    }
}

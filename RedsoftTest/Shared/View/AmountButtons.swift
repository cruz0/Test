import UIKit
import RxSwift

final class AmountButtons: UIView {
    private let disposeBag = DisposeBag()
    private var basketButton: UIButton!
    private lazy var amountMode = false
    
    enum BasketStyle {
        case icon
        case iconWithTitle
    }
    
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
    
    private lazy var minusButton: UIButton = {
        let item = UIButton(type: .custom)
        item.setTitle("-", for: .normal)
        item.titleLabel?.adjustsFontSizeToFitDevice()
        return item
    }()
    
    private lazy var plusButton: UIButton = {
        let item = UIButton(type: .custom)
        item.setTitle("+", for: .normal)
        item.titleLabel?.adjustsFontSizeToFitDevice()
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
    
    private lazy var stack: UIStackView = {
        let item = UIStackView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.axis = .horizontal
        item.alignment = .fill
        item.distribution = .fillEqually
        return item
    }()
    
    var amountChanged: ((_ amount: Int, _ isNew: Bool) -> Void)?
    
    var amount: Int = 0 {
        didSet {
            amountLabel.text = "\(amount) шт"
            if amount < 1 {
                setupControls(amountMode: false)
            } else if !amountMode && amount > 0 {
                setupControls(amountMode: true)
            }
        }
    }
    
    init(basketStyle: BasketStyle) {
        super.init(frame: .zero)
        basketButton = basketStyle == .icon ? basketIconButton : basketIconWithTitleButton
        
        addSubview(stack)
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        basketButton.rx.tap.subscribe {[weak self] _ in
            guard let self = self else {return}
            self.amount = 1
            self.amountChanged?(self.amount, true)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = 4
    }
}

//MARK: - Private
private extension AmountButtons {
    func setupControls(amountMode: Bool) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if amountMode {
            stack.addArrangedSubview(minusButton)
            stack.addArrangedSubview(amountLabel)
            stack.addArrangedSubview(plusButton)
        } else {
            stack.addArrangedSubview(basketButton)
        }
        self.amountMode = amountMode
    }
}

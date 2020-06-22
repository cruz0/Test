import Foundation

final class ProductViewModel {
    private let database: DatabaseManager
    private let productBasket: ProductBasket
    var firstCategory: String? {
        productBasket.product.categories.first?.title
    }
    var categories: [String] {
        productBasket.product.categories.map({$0.title})
    }
    var imageURL: URL? {
        URL(string: productBasket.product.image_url)
    }
    var title: String {
        productBasket.product.title
    }
    var producer: String {
        productBasket.product.producer
    }
    var price: String {
        String(format: "%.2f ₽", productBasket.product.price)
    }
    var shortDescription: String {
        productBasket.product.short_description
    }
    var countInBasket: Int {
        productBasket.count
    }
    
    init(productBasket: ProductBasket, database: DatabaseManager) {
        self.productBasket = productBasket
        self.database = database
    }
    
    func amountChanged(amount: Int, isNew: Bool) {
        if isNew {
            database.basket.add(productBasket.product, count: amount)
        } else {
            database.basket.setCountFor(product: productBasket.product, count: amount)
        }
    }
}

final class RedsoftDbBasket: DatabaseBasket {
    private let filename = "basket.json"
    private let directory: Storage.Directory = .caches
    
    func getCountFor(product: Product) -> Int {
        let a = (fetchBasket().first{ $0.product.id == product.id })?.count ?? 0
        return a
    }
    
    func setCountFor(product: Product, count: Int) {
        var basket = fetchBasket()
        guard let index = (basket.firstIndex { $0.product.id == product.id }) else {return}
        if count < 1 {
            basket.remove(at: index)
        } else {
            basket[index].count = count
        }
        saveBasket(basket)
    }
    
    func add(_ newProduct: Product, count: Int) {
        var basket = fetchBasket()
        guard !(basket.contains{ $0.product.id == newProduct.id }) else { return }
        basket.append(ProductBasket(product: newProduct, count: count))
        saveBasket(basket)
    }
}

//MARK: - Private
private extension RedsoftDbBasket {
    func saveBasket(_ basket: [ProductBasket]) {
        Storage.store(basket, to: directory, as: filename)
    }
    
    func fetchBasket() -> [ProductBasket] {
        Storage.fileExists(filename, in: directory)
            ? Storage.retrieve(filename, from: directory, as: [ProductBasket].self)
            : []
    }
}

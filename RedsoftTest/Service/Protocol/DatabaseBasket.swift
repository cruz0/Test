protocol DatabaseBasket {
    func getCountFor(product: Product) -> Int
    func setCountFor(product: Product, count: Int)
    func add(_ newProduct: Product, count: Int)
}

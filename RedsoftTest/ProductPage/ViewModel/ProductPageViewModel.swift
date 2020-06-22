import RxCocoa

final class ProductPageViewModel: PageViewModel {
    private let productId: Int
    private let productViewModel = BehaviorRelay<ProductViewModel?>(value: nil)
    
    var productViewModelDriver: Driver<ProductViewModel?> {
        productViewModel.asDriver()
    }
    
    init(service: ServiceManager, database: DatabaseManager, productId: Int) {
        self.productId = productId
        super.init(service: service, database: database)
    }
    
    func fetchProduct() {
        isFetching.accept(true)
        service.getProductBy(productId: productId) {[weak self] (data, error) in
            self?.isFetching.accept(false)
            guard error == nil, let data = data else {
                self?.fetchingError.accept(error)
                return
            }
            self?.setProductViewModel(for: data.data)
        }
    }
}

//MARK: - Private
private extension ProductPageViewModel {
    func setProductViewModel(for product: Product) {
        productViewModel.accept(
            ProductViewModel(
                productBasket: ProductBasket(
                    product: product, count: database.basket.getCountFor(product: product)
                ),
                database: database
            )
        )
    }
}

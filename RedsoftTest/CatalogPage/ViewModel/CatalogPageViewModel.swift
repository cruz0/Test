import RxSwift
import RxCocoa

final class CatalogPageViewModel: PageViewModel {
    private let products = BehaviorRelay<[ProductBasket]>(value: [])
    private let isFetchingWithSupplement = BehaviorRelay<Bool>(value: false)
    
    var productsDriver: Driver<[ProductBasket]> {
        products.asDriver()
    }
    var isFetchingWithSupplementDriver: Driver<Bool> {
        isFetchingWithSupplement.asDriver()
    }
    let filterTitle = BehaviorRelay<String>(value: "")
    
    override init(service: ServiceManager, database: DatabaseManager) {
        super.init(service: service, database: database)
        filterTitle
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind {[weak self] filter in
                self?.fetchProducts()
        }.disposed(by: disposeBag)
    }
        
    func fetchProducts(withSuplement: Bool = false) {
        let isFetching = withSuplement ? isFetchingWithSupplement : self.isFetching
        let startFrom = withSuplement ? products.value.count : 0
        
        isFetching.accept(true)
        service.fetchProducts(startFrom: startFrom, maxItems: 10, filterTitle: filterTitle.value) {[weak self] (data, error) in
            isFetching.accept(false)
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.fetchingError.accept(error)
                return
            }
            self.products.accept(
                withSuplement
                    ? self.products.value + data.data.map({
                        ProductBasket(product: $0, count: self.database.basket.getCountFor(product: $0))
                    })
                    : data.data.map({
                        ProductBasket(product: $0, count: self.database.basket.getCountFor(product: $0))
                    })
            )
        }
    }
    
    func updateProduct(by index: Int) {
        let product = products.value[index].product
        guard var dbProduct = (products.value.first{$0.product.id == product.id}) else {return}
        dbProduct.count = database.basket.getCountFor(product: product)
        products.accept(products.value)
    }
    
    func productPageViewModel(for index: Int) -> ProductPageViewModel {
        let product = products.value[index].product
        return ProductPageViewModel(service: service, database: database, productId: product.id)
    }
    
    func productViewModel(for index: Int) -> ProductViewModel {
        let product = products.value[index].product
        return ProductViewModel(productBasket: ProductBasket(product: product, count: database.basket.getCountFor(product: product)), database: database)
    }
}

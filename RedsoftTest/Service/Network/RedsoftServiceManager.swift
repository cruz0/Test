import Moya

final class RedsoftServiceManager: ServiceManager {
    private let provider = MoyaProvider<RedsoftService>()
    private let responseError = "Не удалось получить данные"
    
    func getProductBy(productId: Int, completion: @escaping ProductsCompletion<ProductData>) {
        provider.request(.productById(productId: productId)) {[weak self] result in
            self?.processingFor(result: result, completion: completion)
        }
    }
    
    func fetchProducts(startFrom: Int, maxItems: Int, filterTitle: String, completion: @escaping ProductsCompletion<ProductsData>) {
        provider.request(.products(startFrom: startFrom, maxItems: maxItems, filterTitle: filterTitle)) {[weak self] result in
            self?.processingFor(result: result, completion: completion)
        }
    }
}

//MARK: - Private
private extension RedsoftServiceManager {
    func processingFor<T: Codable>(result: Result<Response, MoyaError>, completion: @escaping ProductsCompletion<T>) {
        switch result {
        case .success(let response):
            do {
                let productData = try JSONDecoder().decode(T.self, from: response.data)
                completion(productData, nil)
            }
            catch let error {
                print(error.localizedDescription)
                completion(nil, responseError)
            }
            break
        case .failure(let error):
            print(error)
            completion(nil, responseError)
            break
        }
    }
}

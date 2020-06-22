import Foundation

protocol ServiceManager {
    typealias ProductsCompletion<T: Codable> = (_ data: T?, _ error: String?)->()
    
    func getProductBy(productId: Int, completion: @escaping ProductsCompletion<ProductData>)
    
    func fetchProducts(startFrom: Int, maxItems: Int, filterTitle: String, completion: @escaping ProductsCompletion<ProductsData>)
}

import Moya

enum RedsoftService {
    case products(startFrom: Int, maxItems: Int, filterTitle: String)
    case productById(productId: Int)
}

extension RedsoftService: TargetType {
    var baseURL: URL {
        URL(string: "https://rstestapi.redsoftdigital.com/api/v1")!
    }
    
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productById(let productId):
            return "products/\(productId)"
        }
    }
    
    var method: Method {
        switch self {
        case .products, .productById:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .products(let startFrom, let maxItems, let filterTitle):
            return .requestParameters(parameters:
                ["startFrom": startFrom, "maxItems": maxItems, "filter[title]": filterTitle]
                , encoding: URLEncoding.queryString)
        case .productById:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}

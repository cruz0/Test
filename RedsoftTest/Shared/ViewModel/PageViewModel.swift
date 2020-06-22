import RxSwift
import RxCocoa

class PageViewModel {
    let disposeBag = DisposeBag()
    let service: ServiceManager
    let database: DatabaseManager
    let fetchingError = BehaviorRelay<String?>(value: nil)
    let isFetching = BehaviorRelay<Bool>(value: false)
    
    var fetchingErrorDriver: Driver<String?> {
        fetchingError.asDriver()
    }
    var isFetchingDriver: Driver<Bool> {
        isFetching.asDriver()
    }
    
    init(service: ServiceManager, database: DatabaseManager) {
        self.service = service
        self.database = database
    }
}

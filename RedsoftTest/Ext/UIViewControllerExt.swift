import UIKit

extension UIViewController {
    func showErrorAlert(_ error: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        guard let error = error else {return}
        let alert = UIAlertController(title: "Упс..", message: error, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: handler))
            
        present(alert, animated: true)
    }
}

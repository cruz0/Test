import UIKit

extension UILabel {
    func adjustsFontSizeToFitDevice() {
        if UIDevice.isSmallDevice {
            font = font.withSize(font.pointSize - 6)
        }
    }
}

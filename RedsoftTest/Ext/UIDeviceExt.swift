//
//  UIDeviceExt.swift
//  RedsoftTest
//
//  Created by Alex on 22.06.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

public extension UIDevice {
    enum ScreenType: Int {
        case iPhone4 = 960
        case iPhone5 = 1136
        case iPhone6 = 1334
        case iPhone6Plus = 2208
        case iPhoneX = 2436
        case Unknown
    }

    static var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
    static var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    static var isSmallDevice: Bool {
        screenType.rawValue <= ScreenType.iPhone5.rawValue
    }
}

//
//  Bundle+Module.swift
//  QRScanner
//
//  Created by woxtu on 2020/11/22.
//

import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle = {
        return Bundle(for: QRScannerView.self)
    }()
}
#endif

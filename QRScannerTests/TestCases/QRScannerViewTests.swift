//
//  QRScannerViewTests.swift
//  QRScannerTests
//
//  Created by wbi on 2019/10/16.
//  Copyright © 2019 mercari.com. All rights reserved.
//

import XCTest
@testable import QRScanner

class QRScannerViewTests: XCTestCase {

    var qrScanner: QRScannerView!
    var delegate: QRScannerSpyDelegate!

    override func setUp() {
        super.setUp()
        qrScanner = QRScannerView()
        delegate = QRScannerSpyDelegate()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testConfigure() {
        let exp = expectation(description: "Fail configure with simulator running")
        delegate.result.didFailure = { error in
            switch error {
            case .deviceFailure:
                break
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        delegate.result.didSuccess = { code in
            XCTFail()
        }
        delegate.result.didChangeTorchActive = { isOn in
            XCTFail()
        }
        qrScanner.configure(delegate: delegate)
        wait(for: [exp], timeout: 0.1)
    }
}

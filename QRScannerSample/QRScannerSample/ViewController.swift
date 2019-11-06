//
//  ViewController.swift
//  QRScannerSample
//
//  Created by wbi on 2019/10/16.
//  Copyright © 2019 mercari.com. All rights reserved.
//

import UIKit
import QRScanner

final class ViewController: UIViewController {
    @IBOutlet var qrScannerView: QRScannerView! {
        didSet {
            qrScannerView.configure(delegate: self)
            qrScannerView.startRunning()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapRetryScanButton(_ sender: UIButton) {
        qrScannerView.rescan()
    }
}

extension ViewController: QRScannerViewDelegate {
    func failure(_ error: QRScannerError) {
        print(error.localizedDescription)
    }

    func success(_ code: String) {
        print(code)
    }
}

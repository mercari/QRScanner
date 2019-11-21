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
    // MARK: - Outlets
    @IBOutlet var qrScannerView: QRScannerView! {
        didSet {
            qrScannerView.configure(delegate: self)
        }
    }
    @IBOutlet var flashButton: FlashButton!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrScannerView.stopRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrScannerView.startRunning()
    }

    // MARK: - Actions
    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
}

// MARK: - QRScannerViewDelegate
extension ViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error.localizedDescription)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        if let url = URL(string: code), (url.scheme == "http" || url.scheme == "https") {
            openWeb(url: url)
        } else {
            showAlert(code: code)
        }
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
}

// MARK: - Private
private extension ViewController {
    func openWeb(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
            self.qrScannerView.rescan()
        })
    }

    func showAlert(code: String) {
        let alertController = UIAlertController(title: code, message: nil, preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { [weak self] _ in
            UIPasteboard.general.string = code
            self?.qrScannerView.rescan()
        }
        alertController.addAction(copyAction)
        let searchWebAction = UIAlertAction(title: "Search Web", style: .default) { [weak self] _ in
            UIApplication.shared.open(URL(string: "https://www.google.com/search?q=\(code)")!, options: [
                :]
                , completionHandler: nil)
            self?.qrScannerView.rescan()
        }
        alertController.addAction(searchWebAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.qrScannerView.rescan()
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

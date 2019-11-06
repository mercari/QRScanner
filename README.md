# QRScanner
A simple QR Code scanner framework for iOS. Provides a similar scan effect to ios13+. Written in Swift.

|iOS 13.0+|QRScanner iOS 10.0+|
|-|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ios13qr.gif" width="350">|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/qr.gif" width="350">|

"QR Code" is a registered trademark of DENSO WAVE INCORPORATED

## Feature
- Similar to iOS 13.0+ design
- Simple usage  <a href="https://github.com/mercari/QRScanner/blob/master/QRScannerSample/QRScannerSample/ViewController.swift" target="_blank">Sample</a>
- Support for iOS 10.0+

## Development Requirements
- iOS 10.0+
- Swift: 5.0
- XCode Version: 10.3 (10G8)

## Installation
<a href="http://cocoapods.org/" target="_blank">CocoaPods</a> is the recommended method of installing QRScanner.

### The Pod Way

- Simply add the following line to your <code>Podfile</code>
```
  platform :ios, '10.0'
  pod 'MercariQRScanner'
```

- Run command
```
  pod install
```
- Write Import statement on your source file
```
  Import MercariQRScanner
```

### The Carthage Way

- Move your project dir and create Cartfile
```
> touch Cartfile
```
- add the following line to Cartfile
```
github "mercari/QRScanner"
```
- Create framework
```
> carthage update --platform iOS
```

- In Xcode, move to "Genera > Build Phase > Linked Frameworks and Library"
- Add the framework to your project
- Add a new run script and put the following code
```
/usr/local/bin/carthage copy-frameworks
```
- Click "+" at Input file and Add the framework path
```
$(SRCROOT)/Carthage/Build/iOS/QRScanner.framework
```
+ Write Import statement on your source file
```
Import QRScanner
```

## Usage

See [QRScannerSample](https://github.com/mercari/QRScanner/tree/master/QRScannerSample)

### Add `Privacy - Camera Usage Description` to Info.plist file

<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/privacy_camera.png" width="500">

### Source Code

```
// If use the Pod way, import MercariQRScanner
import QRScanner

final class ViewController: UIViewController {
    @IBOutlet var qrScannerView: QRScannerView! {
        didSet {
            qrScannerView.configure(delegate: self)
            qrScannerView.startRunning()
        }
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
```
## Committers

* Hitsu ([@hitsubunnu](https://github.com/hitsubunnu))
* Sonny ([@tedbrosby](https://github.com/tedbrosby))
* Daichiro ([@daichiro](https://github.com/daichiro))

## Contribution

Please read the CLA carefully before submitting your contribution to Mercari.
Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

https://www.mercari.com/cla/

## License

Copyright 2019 Mercari, Inc.

Licensed under the MIT License.

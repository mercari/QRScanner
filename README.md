# QRScanner
A simple QR Code scanner framework for iOS. Provides a similar scan effect to ios13+. Written in Swift.

* [日本語のブログ](https://tech.mercari.com/entry/2019/12/12/094129)

|iOS 13.0+| Use QRScanner in iOS 10.0+|
|-|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ios13qr.gif" width="350">|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/qr.gif" width="350">|

"QR Code" is a registered trademark of DENSO WAVE INCORPORATED

## Feature
- Similar to iOS 13.0+ design
- Simple usage  <a href="https://github.com/mercari/QRScanner/blob/master/QRScannerSample/QRScannerSample/ViewController.swift" target="_blank">UIKit Sample</a> | <a href="https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample" target="_blank">SwiftUI Sample</a>
- Support SwiftUI (iOS 14.0+)
- Support from iOS 14.0+

## Development Requirements
- iOS 14.0+
- Swift: 5.7.1
- Xcode Version: 16.0+

## Installation

### Swift Package Manager

Once you have your Swift package set up, adding QRScanner as a dependency is as easy as adding it to the dependencies value of your <code>Package.swift</code>.
```swift
dependencies: [
    .package(url: "https://github.com/mercari/QRScanner.git", .upToNextMajor(from: "1.9.0"))
]
```

Or add it through Xcode:
1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/mercari/QRScanner.git`
3. Select the version range and add to your target

Write Import statement on your source file:
```swift
import QRScanner
```

## Usage

See [QRScannerSample](https://github.com/mercari/QRScanner/tree/master/QRScannerSample) for UIKit usage or [QRScannerSwiftUISample](https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample) for SwiftUI usage.

### Add `Privacy - Camera Usage Description` to Info.plist file

<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/privacy_camera.png" width="500">

## SwiftUI Usage

### Basic SwiftUI Implementation

```swift
import SwiftUI
import QRScanner
import AVFoundation

struct ContentView: View {
    @State private var scannedCode = ""
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button("Start Scanning") {
                isPresented = true
            }
            
            if !scannedCode.isEmpty {
                Text("Scanned: \(scannedCode)")
            }
        }
        .sheet(isPresented: $isPresented) {
            QRScannerSwiftUIView(
                onSuccess: { code in
                    scannedCode = code
                    isPresented = false
                },
                onFailure: { error in
                    print("Scan error: \(error)")
                    isPresented = false
                }
            )
        }
    }
}
```

### Advanced SwiftUI Usage with Controls

```swift
struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var torchActive = false
    
    var body: some View {
        VStack {
            QRScannerSwiftUIView(
                configuration: .init(
                    focusImagePadding: 12.0,
                    animationDuration: 0.3,
                    isBlurEffectEnabled: true
                ),
                isScanning: $isScanning,
                torchActive: $torchActive,
                onSuccess: { code in
                    scannedCode = code
                    isScanning = false
                },
                onFailure: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )
            
            HStack {
                Button(isScanning ? "Pause" : "Resume") {
                    isScanning.toggle()
                }
                
                Button("Torch") {
                    torchActive.toggle()
                }
            }
            .padding()
        }
    }
}
```

### SwiftUI Configuration Options

#### Configuration Parameters
- `focusImage`: Custom focus frame image
- `focusImagePadding`: Focus frame padding (default: 8.0)
- `animationDuration`: Animation duration (default: 0.5)
- `isBlurEffectEnabled`: Enable blur effect (default: false)

#### Binding Parameters
- `isScanning`: Control scanning state
- `torchActive`: Control torch state

#### Callback Functions
- `onSuccess`: Scan success callback
- `onFailure`: Scan failure callback
- `onTorchActiveChange`: Torch state change callback

For a complete SwiftUI example, see [QRScannerSwiftUISample](https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample).

## UIKit Usage

### Basic UIKit Implementation

```swift
import QRScanner
import AVFoundation

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
    }

    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }

    private func setupQRScannerView() {
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension ViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
    }
}
```

### UIKit Customization

#### Source Code Way

```swift
override func viewDidLoad() {
        super.viewDidLoad()

        let qrScannerView = QRScannerView(frame: view.bounds)

        // Customize focusImage, focusImagePadding, animationDuration
        qrScannerView.focusImage = UIImage(named: "scan_qr_focus")
        qrScannerView.focusImagePadding = 8.0
        qrScannerView.animationDuration = 0.5

        qrScannerView.configure(delegate: self)
        view.addSubview(qrScannerView)
        qrScannerView.startRunning()
}
```

#### Interface Builder Way

|Setup Custom Class|Customize|
|-|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ib2.png" width="350">|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ib1.png" width="350">|

### UIKit Add FlashButton

[FlashButtonSample](https://github.com/mercari/QRScanner/blob/master/QRScannerSample/QRScannerSample/FlashButton.swift)

```swift
final class ViewController: UIViewController {

    ...

    @IBOutlet var flashButton: FlashButton!

    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
}

extension ViewController: QRScannerViewDelegate {

    ...

    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
}
```

### UIKit Add Blur Effect

#### Source Code Way

```swift
     qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
```

#### Interface Builder Way

|Customize|
|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ib1.png" width="350">|

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

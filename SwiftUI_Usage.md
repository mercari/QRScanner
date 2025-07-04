# QRScanner SwiftUI Usage Guide

## Overview

QRScanner now supports SwiftUI through the `QRScannerSwiftUIView` wrapper, making it easy to integrate into SwiftUI applications.

## Basic Usage

### 1. Import Libraries

```swift
import SwiftUI
import QRScanner
import AVFoundation
```

### 2. Simple Usage

```swift
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

### 3. Advanced Usage - With Controls

```swift
struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var torchActive = false
    @State private var errorMessage = ""
    
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
                    errorMessage = error.localizedDescription
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

## Configuration Options

### Configuration Parameters

- `focusImage`: Custom focus frame image
- `focusImagePadding`: Focus frame padding (default: 8.0)
- `animationDuration`: Animation duration (default: 0.5)
- `isBlurEffectEnabled`: Enable blur effect (default: false)

### Binding Parameters

- `isScanning`: Control scanning state
- `torchActive`: Control torch state

### Callback Functions

- `onSuccess`: Scan success callback
- `onFailure`: Scan failure callback
- `onTorchActiveChange`: Torch state change callback

## Permission Handling

Camera permission is required before use:

```swift
private func requestCameraPermission() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        // Authorized, can start scanning
        break
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    // Permission granted
                } else {
                    // Permission denied
                }
            }
        }
    case .denied, .restricted:
        // Show settings alert
        break
    @unknown default:
        break
    }
}
```

## Important Notes

1. Ensure camera usage description is added to Info.plist
2. QRScannerSwiftUIView requires iOS 13.0+
3. Scanning automatically stops after success, can restart via isScanning
4. Recommended to stop scanning when view disappears to save battery

## Sample Project

For complete example code, refer to the `QRScannerSwiftUISample` directory.
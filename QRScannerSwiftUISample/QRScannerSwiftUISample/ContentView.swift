import SwiftUI
import QRScanner
import AVFoundation

struct ContentView: View {
    @State private var isScanning = true
    @State private var isTorchOn = false
    
    var body: some View {
        ZStack {
            QRScannerSwiftUIView(
                configuration: .init(isBlurEffectEnabled: true),
                isScanning: $isScanning,
                torchActive: $isTorchOn,
                onSuccess: { qrCode in
                    print("QR Code scanned: \(qrCode)")
                },
                onFailure: { error in
                    print("QR Scanner error: \(error.localizedDescription)")
                },
                onTorchActiveChange: { isOn in
                    isTorchOn = isOn
                }
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setupQRScanner()
            }
            .onDisappear {
                isScanning = false
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isTorchOn.toggle()
                    }) {
                        Image(systemName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isScanning = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isScanning = true
                    } else {
                        print("Camera is required to use in this application")
                    }
                }
            }
        default:
            print("Camera access denied or restricted")
        }
    }
}

#Preview {
    ContentView()
}

//
//  ScanPage.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 25/04/24.
//

import SwiftUI
import Vision
import VisionKit

struct ScanPage: View {
    @State private var scannedText: String = ""
    @State private var isScanningComplete = false
    @State private var isPresentingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var shouldNavigateToEditPage = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("SCAN RECIPE")
                          .fontWeight(.bold)
                          .tracking(2.24)
                          .foregroundColor(.black)
                          .font(.largeTitle)
                          .padding(.bottom,8)
                    Spacer()

                }
                Text("Simply scan or input your recipe into Secret Formula to effortlessly transform it into gram-accurate quantities!")
                      .font(Font.custom("SF", size: 13))
                      .tracking(1.04)
                      .foregroundColor(.black)
                      .multilineTextAlignment(.center)
                      .padding(.horizontal,5)
                Spacer()
                DocumentScannerView(scannedText: $scannedText) {
                    self.isScanningComplete = true
                }
                .frame(width: 300, height: 450)
                .background(Color(red: 0.992, green: 0.957, blue: 0.890))
                Spacer()
                HStack {
                    Button(action: {
                        self.isPresentingImagePicker = true
                    }) {
                        Text("Upload from Gallery")
                            .padding()
                    }
                    .sheet(isPresented: $isPresentingImagePicker, onDismiss: {
                        if let image = self.selectedImage {
                            self.processImage(image)
                        }
                    }) {
                        ImagePicker(selectedImage: self.$selectedImage)
                    }
                    Button(action: {
                        self.shouldNavigateToEditPage = true
                    }) {
                        Text("Save & Edit")
                            .padding()
                    }
                    .background(NavigationLink(destination: EditPage(scannedText: $scannedText), isActive: $shouldNavigateToEditPage) {
                        EmptyView()
                    })
                }
            }
            .padding()
            .onAppear {
                self.isScanningComplete = false
            }
            .background(Color(red: 0.992, green: 0.957, blue: 0.890))

        }
    }

    func processImage(_ image: UIImage) {
        if let ciImage = CIImage(image: image) {
            let request = VNRecognizeTextRequest(completionHandler: { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                var extractedText = ""
                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else { continue }
                    extractedText += bestCandidate.string + "\n"
                }
                self.scannedText = extractedText
                self.shouldNavigateToEditPage = true
            })

            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String
    var completionHandler: (() -> Void)?

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        // Hide the default button for capturing a picture
        scannerViewController.navigationItem.rightBarButtonItem = nil
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(scannedText: $scannedText, completionHandler: completionHandler)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scannedText: String
        var completionHandler: (() -> Void)?

        init(scannedText: Binding<String>, completionHandler: (() -> Void)?) {
            _scannedText = scannedText
            self.completionHandler = completionHandler
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var extractedText = ""
            for pageNumber in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageNumber)
                if let ciImage = CIImage(image: image) {
                    let request = VNRecognizeTextRequest(completionHandler: { request, error in
                        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                        for observation in observations {
                            guard let bestCandidate = observation.topCandidates(1).first else { continue }
                            extractedText += bestCandidate.string + "\n"
                        }
                    })

                    let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
                    do {
                        try handler.perform([request])
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            scannedText = extractedText
            completionHandler?()
            controller.dismiss(animated: true, completion: nil)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler?()
            controller.dismiss(animated: true, completion: nil)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanning failed with error: \(error)")
            completionHandler?()
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = pickedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


#Preview {
    ScanPage()
}

//
//  ContentView.swift
//  ScanBox
//
//  Created by Victor Augusto Toledo Lúcio Borghi on 10/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showInvalidMessage = false
    
    let validCodes = [
        "https://pt.wikipedia.org",
        "https://pt.wikipedia.org/wiki/Código_QR",
        "https://pt.wikipedia.org/wiki/C%C3%B3digo_QR",
        "PACOTE-HACKATHON-001",
        "PACOTE-HACKATHON-002",
        "PACOTE-HACKATHON-003"
    ]
    
    let amarelo = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    var body: some View {
        ZStack {
            if showCamera {
                if capturedImage != nil {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        
                        VStack {
                            HStack {
                                Button(action: {
                                    showCamera = false
                                    scannedCode = nil
                                    capturedImage = nil
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Voltar")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(12)
                                    .background(amarelo)
                                    .cornerRadius(10)
                                }
                                Spacer()
                            }
                            .padding(20)
                            
                            Spacer()
                            
                            Image(uiImage: capturedImage!)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding(20)
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    capturedImage = nil
                                    showImagePicker = true
                                }) {
                                    Text("Tirar outra")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(amarelo)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    print("Entrega confirmada com foto!")
                                    showCamera = false
                                    scannedCode = nil
                                    capturedImage = nil
                                }) {
                                    Text("Confirmar Entrega")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(20)
                        }
                    }
                } else {
                    ImagePickerView(image: $capturedImage, isPresented: $showImagePicker)
                        .ignoresSafeArea()
                }
                
            } else {
                ScannerView(scannedCode: $scannedCode)
                    .ignoresSafeArea()
                    .onChange(of: scannedCode) { newValue in
                        if newValue != nil {
                            showInvalidMessage = !isCodeValid()
                        }
                    }
                
                VStack(spacing: 0) {
                    Text("ScanBox")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(amarelo)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.3))
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            scannedCode == nil ? amarelo : isCodeValid() ? Color.green : Color.red,
                            lineWidth: 4
                        )
                        .frame(width: 250, height: 250)
                        .background(Color.black.opacity(0.1))
                    
                    if showInvalidMessage {
                        Text("❌ Código Inválido")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if scannedCode != nil {
                                if isCodeValid() {
                                    capturedImage = nil
                                    showImagePicker = true
                                    showCamera = true
                                    showInvalidMessage = false
                                } else {
                                    showInvalidMessage = true
                                }
                            }
                        }) {
                            Text(scannedCode == nil ? "Aguardando..." : "Confirmar")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(scannedCode == nil ? Color.gray : isCodeValid() ? amarelo : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(scannedCode == nil || !isCodeValid())
                        
                        Button(action: {
                            scannedCode = nil
                            showInvalidMessage = false
                        }) {
                            Text("Limpar")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(amarelo)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(image: $capturedImage, isPresented: $showImagePicker)
        }
    }
    
    func isCodeValid() -> Bool {
        guard let code = scannedCode else { return false }
        let normalizedCode = code.removingPercentEncoding ?? code
        return validCodes.contains { entry in
            let normalizedEntry = entry.removingPercentEncoding ?? entry
            return normalizedEntry == normalizedCode
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

#Preview {
    ContentView()
}

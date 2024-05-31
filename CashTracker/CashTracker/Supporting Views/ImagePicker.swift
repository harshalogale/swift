//
//  ImagePicker.swift
//  CashTracker
//
//  Created by Vlad Lego on 15/07/2019.
//  vlad@iSelf.com
//

import Foundation
import SwiftUI
import Combine

final class ImagePicker: ObservableObject {
    
    static let shared: ImagePicker = ImagePicker()
    
    private init() {}  //force using the singleton: ImagePicker.shared
    
    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()
    
    static var pickerType:UIImagePickerController.SourceType = .photoLibrary
    
    // Bindable Object part
    let willChange = PassthroughSubject<(Image?, Data?), Never>()
    
    @Published var imageInfo: (Image?, Data?)? = nil {
        didSet {
            if imageInfo != nil {
                willChange.send(imageInfo!)
            }
        }
    }
}


extension ImagePicker {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            var uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiImage = fixOrientation(img: uiImage)
            
            ImagePicker.shared.imageInfo = (Image(uiImage: uiImage), uiImage.pngData())
            picker.dismiss(animated:true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
        
        func fixOrientation(img: UIImage) -> UIImage {
            if (img.imageOrientation == .up) {
                return img
            }
            
            UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
            let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            img.draw(in: rect)
            
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return normalizedImage
        }
    }
    
    
    struct View: UIViewControllerRepresentable {
        
        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = pickerType
            //picker.allowsEditing = true
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {
            
        }
    }
}


struct ImagePickerTestView: View {
    
    @State var showingPicker = false
    
    @State var image: Image? = nil
    @State var imageData: Data? = nil
    // you could use ImagePicker.shared.image directly
    
    var body: some View {
        VStack {
            Button("Show Image Picker") {
                self.showingPicker = true
            }
            
            if nil != image {
                ZStack {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                    
                    Button(action: {
                        self.image  =  nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }.position(x: 0, y: 0)
                }
            }
        }.sheet(isPresented: $showingPicker,
                content: {
                    ImagePicker.shared.view
        })
            .onReceive(ImagePicker.shared.$imageInfo) { imageInfo in
                // This gets called when the image is picked.
                // sheet/onDismiss gets called when the picker completely leaves the screen
                self.image = imageInfo?.0
                self.imageData = imageInfo?.1
        }
    }
    
}


#if DEBUG
struct ImagePicker_Previews: PreviewProvider {
    
    static var previews: some View {
        ImagePickerTestView()
    }
}
#endif

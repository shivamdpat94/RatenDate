//
//  ImagePicker.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/2/24.
//
// ImagePicker.swift

import SwiftUI
import PhotosUI  // Important for PHPickerViewController

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var completion: () -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        self.parent.completion()
                    }
                }
            }
        }
    }
}



struct ImagePicker_Previews: PreviewProvider {
    @State static var image: UIImage? = nil  // Placeholder for the selected image

    static var previews: some View {
        // ImagePicker expects a Binding<UIImage?>, so provide one.
        ImagePicker(selectedImage: $image) {
            // Handle the completion action here
        }
    }
}

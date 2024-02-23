//
//  ImagePicker.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/2/24.
//
// ImagePicker.swift

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var completion: () -> Void
    var allowsEditing: Bool = true  // Allow editing to enable cropping

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = allowsEditing  // Enable cropping
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Use the edited image if available, otherwise the original image
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            picker.dismiss(animated: true)
            parent.completion()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
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

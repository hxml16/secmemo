//
//  ImagePicker.swift
//  secmemo
//
//  Created by heximal on 13.03.2022.
//

import Foundation
import UIKit

typealias PickPhotoCompletion = ((UIImage) -> ())

class ImagePicker: NSObject {
    var onComplete: PickPhotoCompletion?
    var pickerController = UIImagePickerController()
    
    func pickPhotoFromLibrary(inController: UIViewController, onComplete: @escaping PickPhotoCompletion) {
        pickPhoto(sourceType: .photoLibrary, inController: inController, onComplete: onComplete)
    }

    func pickPhotoFromCamera(inController: UIViewController, onComplete: @escaping PickPhotoCompletion) {
        pickPhoto(sourceType: .camera, inController: inController, onComplete: onComplete)
    }

    private func pickPhoto(sourceType: UIImagePickerController.SourceType, inController: UIViewController, onComplete: @escaping PickPhotoCompletion) {
        self.onComplete = onComplete
        pickerController.allowsEditing = false
        pickerController.sourceType = sourceType
        pickerController.mediaTypes = ["public.image"]
        pickerController.delegate = self
        inController.present(pickerController, animated: true)
    }
}

//MARK: UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        onComplete?(image)
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: UINavigationControllerDelegate
extension ImagePicker: UINavigationControllerDelegate {
}

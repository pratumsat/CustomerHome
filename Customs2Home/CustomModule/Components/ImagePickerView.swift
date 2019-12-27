//
//  ImagePickerView.swift
//  Customs2Home
//
//  Created by warodom on 19/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, imageURL: URL?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    var pickImageCallback:((UIImage? , URL?)->Void)?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
//        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView, _ callback:( (UIImage?, URL?)->Void)? ) {
        self.pickImageCallback = callback
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?,imageURL: URL?) {
        controller.dismiss(animated: true, completion: nil)
        self.pickImageCallback?(image, imageURL)
        self.delegate?.didSelect(image: image, imageURL: imageURL)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, imageURL: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil,imageURL: nil)
        }
      
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return self.pickerController(picker, didSelect: image,imageURL: URL(string: "https://c2hfakeurl.com/image/\(Date().DateToServerFormatString(format: "YYYY-MM-ddHH:MM:ss.s")).jpeg"))
        }
        
        self.pickerController(picker, didSelect: image,imageURL: imageURL)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}

//
//  DeclarationView.swift
//  Customs2Home
//
//  Created by warodom on 18/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class DeclarationView: UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    var modelUrl:(String,UIImage)?
    
    var imageFile: UIImage? {
        didSet {
            self.imageView.image = imageFile
        }
    }
    var imageURL: URL?{
        didSet {
            btnSelectImage.setTitle(imageURL?.lastPathComponent, for: .normal)
        }
    }
    
    


}

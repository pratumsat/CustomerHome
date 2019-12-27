//
//  DeclarationNav.swift
//  Customs2Home
//
//  Created by thanawat on 12/2/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit

class PaymentNav: UINavigationController {

    var declareId:String?
    var payment_method:String?
    var fromTab:Bool = false
    var dismissCallback: (() -> Void)?
    var email:String?
    
    func prepareData(declareId:String?, payment_method:String? = nil, email: String?,  fromTab:Bool = false , dismissCallback: (() -> Void)?){

        self.declareId = declareId
        self.dismissCallback = dismissCallback
        self.payment_method = payment_method
        self.fromTab = fromTab
        self.email = email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentationController?.delegate = self
    }
    

}

extension PaymentNav: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss")
        dismissCallback?()
    }
}

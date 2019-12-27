//
//  ItemView.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 22/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit

class ItemView: UIView {
    @IBOutlet weak var tariffButton:TariffButton!
    @IBOutlet weak var priceText:UITextField!
    @IBOutlet weak var qtyText:UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var scrollViewButton: UIScrollView!
    
    var tariffIdentify:Int? {
        guard let id = tariffButton.tariff?.tariffID else {
            return nil
        }
        return toInt(id)
    }
    
    func isEqual(_ object: ItemView?) -> Bool {
        return self.tariffIdentify == object?.tariffIdentify
    }
    
    var preDeclareList: PreDeclareList? {
        guard let tariff = tariffButton.tariff else { return nil }
        
        return PreDeclareList ( tariff: tariff ,  price: toDouble( priceText.text?.splitComma ) , qty: toInt( qtyText.text?.splitComma ) )
    }
    var isShowMsgWarning:Bool = false
    var isShowViewMsgWarning:Bool = false {
        didSet {
            let isShow = isShowViewMsgWarning
            let str = tariffButton.tariff?.msgWarning
            
            self.warningLabel.superview?.isHidden = !isShow
            self.warningLabel.text = str
            
            
            self.qtyLabel.textColor = !isShow ? .black : .redThemeColor
            self.qtyView.borderColor = !isShow ? .borderThemeColor : .redThemeColor
            
            //let qtyLabel = self.view(withId: "QtyLabel") as! UILabel
            //qtyLabel.textColor = !isShow ? UIColor.black : UIColor(named: "Red-Theme")
        }
    }
    
}


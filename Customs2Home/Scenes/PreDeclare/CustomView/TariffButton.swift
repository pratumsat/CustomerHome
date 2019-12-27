//
//  TarButton.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 21/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TariffButton: KButton {
    
    var tariffRelay = BehaviorRelay<TariffList?>.init(value: nil)
    var tariff :TariffList? {
        return tariffRelay.value
    }
    
    override func awakeFromNib() {
        self.disposeBag = DisposeBag()
        tariffRelay.filter( { $0 != nil} ).bind(onNext: { (tariff) in
            let string = NSMutableString()
            let array = [ tariff?.categoryName, tariff?.subCategory , tariff?.tariffName ]
            array.enumerated().forEach({ (offset,name) in
                if offset != 0 {
                    string.append( " > " + toString(name) )
                }
                else {
                    string.append( toString(name) )
                }
            })
            self.setTitle( String(string) , for:  UIControl.State.normal )
            self.setTitleColor(UIColor.black, for: .normal)
            
            self.sizeThatFits(CGSize(width: self.intrinsicContentSize.width + 10, height: self.intrinsicContentSize.height + 10))
        }).disposed(by: self.disposeBag!)
    }
    
}

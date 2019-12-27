//
//  UITextField+Filter.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 19/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
extension UITextField {
    
    func limitText( degit:Int) -> Disposable {
        return self.rx.text.map { String($0?.prefix(degit) ?? "")}.bind(to: self.rx.text)
    }
}

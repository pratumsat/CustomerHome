//
//  FormView.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 26/8/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FormView: UIView {
    let text:KTextField = KTextField()
    weak var formModel:FormModel?
    func bind(model:FormModel) -> CompositeDisposable
    {
        self.formModel = model
        var disposables = [Disposable]()
        
        model.map.forEach { (bindingData) in
            if let view = self.view(withId: bindingData.textKey) {
                if let dispose = bindEach(view: view, bindingData: bindingData) {
                     disposables.append(dispose)
                }
            }
        }
        return CompositeDisposable(disposables: disposables)
    }
    func submitForm()
    {
        self.formModel?.map.forEach({ (bindingData) in
            if let view = self.view(withId: bindingData.textKey)  {
                if let customData = bindingData.customData {
                    customData(view)
                }
                else if bindingData.type == .text,
                    let textField = view as? UITextField {
                    bindingData.getRelay()?.accept(textField.text)
                }
            }
        })
    }
    
    private func bindEach(view:UIView,bindingData:BindingData  ) -> Disposable?  {
        
        if let customBind = bindingData.customBind {
            return customBind(view)
        }
        guard let textField = view as? UITextField else { return nil }
        
        switch bindingData.type {
        case .text:
            return bindingData.getRelay()?.bind(to: textField.rx.text)
        case .kTextError:
            if let textField = textField as? KTextField
            {
                return bindingData.getRelay()?.bind(onNext: { str in
                    textField.setErrorMsg(str)
                })
            }
        }
        return nil
    }
    
   
}

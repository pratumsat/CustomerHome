//
//  AddressViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 12/3/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class AddressViewModel: BaseViewModel<AddressViewModel>,ViewModelProtocol {

    typealias M = AddressViewModel
    typealias T = AddressViewController
    static var obj_instance: AddressViewModel?
    
    var addressRelay = BehaviorRelay<String>(value: "")

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
       
        let addressViewModel = TextFieldViewModel(errorMessage: "กรุณากรอกข้อมูลให้ครบถ้วน")
        
        let address = input.address.bind(to: addressViewModel.data)

        commonDispose.append(address)
        
        
        
        
        let errorValidate = addressViewModel.errorValue.filter({$0 != nil})
        
        let validateNextTapped = input.confirmTapped
            .filter( { addressViewModel.validateCredentials() })
            .map({[unowned self] _ -> String in
                let address = self.viewControl?.addressTextField.text ?? ""
                let subDistrict = self.viewControl?.textFieldSubDistrict.titleLabel?.text ?? ""
                let district = self.viewControl?.textFieldDistrict.titleLabel?.text ?? ""
                let province = self.viewControl?.textFieldProvince.titleLabel?.text ?? ""
                let postCode = self.viewControl?.textFieldPostcode.titleLabel?.text ?? ""
                let fulladdress = "\(address) \(subDistrict) \(district) \(province) รหัสไปรษณีย์ \(postCode)"
                
                self.addressRelay.accept(address)
                
                return fulladdress
            })
        
        return AddressViewModel.Output(validate: validateNextTapped,
                                        errorValidate: errorValidate,
                                        commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    
}

extension AddressViewModel {
    struct Input {
        let address: Observable<String>
        let confirmTapped: Observable<Void>
    }
    
    struct Output {
        let validate: Observable<String>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

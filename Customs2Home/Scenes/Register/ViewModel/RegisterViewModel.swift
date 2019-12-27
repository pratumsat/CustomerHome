//
//  RegisterViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/15/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class RegisterViewModel: BaseViewModel<RegisterViewModel>,ViewModelProtocol {

    typealias M = RegisterViewModel
    typealias T = RegisterViewController
    static var obj_instance: RegisterViewModel?
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
//        let item = input.onLoadView.flatMapLatest( fecthdata )
        
        let firstNameViewModel = NameViewModel(errorMessage: "ชื่อต้องเป็นภาษาไทย และมีอย่างละไม่น้อยกว่า 2 ตัวอักษรและไม่เกิน 50 ตัวอักษร")
        let lastNameViewModel = NameViewModel(errorMessage: "นามสกุลต้องเป็นภาษาไทย และมีอย่างละไม่น้อยกว่า 2 ตัวอักษรและไม่เกิน 50 ตัวอักษร")
        let mobileViewModel = MobileViewModel()
        let birthdateViewModel = TextFieldViewModel(errorMessage: "กรุณากรอกข้อมูลให้ครบถ้วน")
        let addressViewModel = TextFieldViewModel(errorMessage: "กรุณากรอกข้อมูลให้ครบถ้วน")
        
        let firstName = input.firstName.bind(to: firstNameViewModel.data)
        let lastName = input.lastName.bind(to: lastNameViewModel.data)
        let brithdate = input.brithdate.bind(to: birthdateViewModel.data)
        let mobile = input.mobile.bind(to: mobileViewModel.data)
        let address = input.address.bind(to: addressViewModel.data)
        
        commonDispose.append(firstName)
        commonDispose.append(lastName)
        commonDispose.append(brithdate)
        commonDispose.append(mobile)
        commonDispose.append(address)
        
        
        
        
        let errorValidate = Observable.merge(firstNameViewModel.errorValue.filter({$0 != nil}),
                                             lastNameViewModel.errorValue.filter({$0 != nil}),
                                             birthdateViewModel.errorValue.filter({$0 != nil}),
                                             mobileViewModel.errorValue.filter({$0 != nil}),
                                             addressViewModel.errorValue.filter({$0 != nil}))
   
        let validateNextTapped = input.nextTapped
            .filter( {  firstNameViewModel.validateCredentials()
                        && lastNameViewModel.validateCredentials()
                        && birthdateViewModel.validateCredentials()
                        && mobileViewModel.validateCredentials()
                        && addressViewModel.validateCredentials()
            })
            .map({ _ -> Bool in
                return true
            })
        
        return RegisterViewModel.Output(validate: validateNextTapped,
                                        errorValidate: errorValidate,
                                        commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata() -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen
            else {return .just([])}
        
        let service = Observable.just(true)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:Bool) -> [KTableCellSection]
    {
        let sections = [KTableCellSection]()
        return sections
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension RegisterViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let firstName: Observable<String>
        let lastName: Observable<String>
        let brithdate: Observable<String>
        let mobile: Observable<String>
        let address: Observable<String>
        let nextTapped: Observable<Void>
    }
    
    struct Output {
        let validate: Observable<Bool>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

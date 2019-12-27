//
//  CreatePasswordViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/18/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class CreatePasswordViewModel: BaseViewModel<CreatePasswordViewModel>,ViewModelProtocol {

    typealias M = CreatePasswordViewModel
    typealias T = CreatePasswordViewContrloller
    static var obj_instance: CreatePasswordViewModel?
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        //let item = input.onLoadView.flatMapLatest( fecthdata )
        
        let emailViewModel = EmailViewModel()
        let passwordViewModel = PasswordViewModel()
        let confirmPasswordViewModel = PasswordViewModel()
        
        let email = input.email.bind(to: emailViewModel.data)
        let password = input.password.bind(to: passwordViewModel.data)
        let confirmPassword = input.confirmPassword.bind(to: confirmPasswordViewModel.data)
        
        commonDispose.append(email)
        commonDispose.append(password)
        commonDispose.append(confirmPassword)
        
        let matchPassword = input.register
            .filter({ emailViewModel.validateCredentials()
                    && passwordViewModel.validateCredentials()
                    && confirmPasswordViewModel.validateCredentials() })
            .map({ passwordViewModel.data.value == confirmPasswordViewModel.data.value })
        
        let errorValidate = Observable.merge(emailViewModel.errorValue.filter({$0 != nil}),
                                             passwordViewModel.errorValue.filter({$0 != nil}) ,
                                             confirmPasswordViewModel.errorValue.filter({$0 != nil}),
                                             matchPassword.filter({ !$0 }).map({ _ in "กรุณากรอกรหัสผ่านให้เหมือนกัน"}))

        let register = matchPassword
            .filter({ $0 }) //isMatch
            .map({ _ in (emailViewModel.data.value,  passwordViewModel.data.value) })
            .flatMapLatest( fecthdata )
        
        return CreatePasswordViewModel.Output( registerSuccess: register,
                                            errorValidate: errorValidate,
                                            commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(email:String, password:String) -> Observable<Response_Register?> {
        
        guard let loadingScreen = self.loadingScreen else { return .just((nil)) }
        var base = BaseRequest_Register()
        base.importerRegisterReq = viewControl?.importerAddEditReq
        base.importerRegisterReq?.email = viewControl?.textfieldEmail.text
        base.importerRegisterReq?.password = viewControl?.textfieldPassword.text
        base.importerRegisterReq?.confirmPassword = viewControl?.textfieldConfirmPassword.text
//        base.importerRegisterReq?.condition = Condition(userId: "1")
    
       
        
        
        //let service = Observable.just(true)
        let service = PostRegisterApi().callService(request: base)
        let loading = loadingScreen.observeLoading(service, shouldRetry: { [unowned self] (error) -> Bool in
                guard let k_error = error as? KError else {return false}
                let errorMessage = k_error.getMessage
                let code = " (\(toString( errorMessage.codeString )))"
                self.viewControl?.alert(message: toString( errorMessage.message ) + code)
                return false
            })
            .map({ respond -> Response_Register? in
                return respond
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
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

extension CreatePasswordViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let email: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let register: Observable<Void>
    }
    
    struct Output {
        let registerSuccess: Observable<Response_Register?>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

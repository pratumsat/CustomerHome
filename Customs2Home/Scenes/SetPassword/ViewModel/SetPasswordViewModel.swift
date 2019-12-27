//
//  SetPasswordViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/11/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class SetPasswordViewModel: BaseViewModel<SetPasswordViewModel>,ViewModelProtocol {

    typealias M = SetPasswordViewModel
    typealias T = SetPasswordViewController
    static var obj_instance: SetPasswordViewModel?
    

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let dataObservable = input.onLoadView
        
        let passwordViewModel = PasswordViewModel()
        let confirmPasswordViewModel = PasswordViewModel()
        
        let password = input.password.bind(to: passwordViewModel.data)
        commonDispose.append(password)

        let confirmPassword = input.confirmPassword.bind(to: confirmPasswordViewModel.data)
        commonDispose.append(confirmPassword)

        let matchPassword = input.save
            .filter({ passwordViewModel.validateCredentials() && confirmPasswordViewModel.validateCredentials() })
            .map({ passwordViewModel.data.value == confirmPasswordViewModel.data.value })

        let errorValidate = Observable.merge(passwordViewModel.errorValue.filter({$0 != nil}) ,
                                             confirmPasswordViewModel.errorValue.filter({$0 != nil}),
                                             matchPassword.filter({ !$0 }).map({ _ in "กรุณากรอกรหัสผ่านให้เหมือนกัน"}))
        
        let setPassword = matchPassword
            .filter({ $0 }) //isMatch
            .map({ _ in passwordViewModel.data.value })
            .withLatestFrom(dataObservable, resultSelector: { ($0, $1) })
            .flatMapLatest( fecthdata )

        return SetPasswordViewModel.Output( setPasswordSuccess: setPassword.filter({ $0 }),
                                            errorValidate: errorValidate,
                                            commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func fecthdata(password:String , data:(Int,String)?) -> Observable<Bool> {
        
        guard let loadingScreen = self.loadingScreen else { return .just((false)) }
        
        let forgetPasswordConfirmReq = ForgetPasswordConfirmReq(userId: data?.0,
                                                                otpRef: data?.1,
                                                                password: password,
                                                                confirmPassword: password)
        
        let baseRequest = BaseRequestForgetPasswordConfirm(forgetPasswordConfirmReq: forgetPasswordConfirmReq)
        let service = GetForgotPasswordConfirmApi().callService(request: baseRequest)
        let loading = loadingScreen.observeLoading(service, shouldRetry: { (error) -> Bool in
                guard let k_error = error as? KError else {return false}
                let errorMessage = k_error.getMessage
                let code = " (\(toString( errorMessage.codeString )))"
                self.viewControl?.alert(message: toString( errorMessage.message ) + code)
                return false
            })
            .map({ respond -> Bool in
                return true
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

extension SetPasswordViewModel {
    struct Input {
        let onLoadView: Observable<(Int,String)?>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let save: Observable<Void>
    }
    
    struct Output {
        let setPasswordSuccess: Observable<Bool>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

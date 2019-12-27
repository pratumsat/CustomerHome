//
//  ForgotPasswordViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/12/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ForgotPasswordViewModel: BaseViewModel<ForgotPasswordViewModel>,ViewModelProtocol {

    typealias M = ForgotPasswordViewModel
    typealias T = ForgotPasswordViewController
    static var obj_instance: ForgotPasswordViewModel?
    

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        
        let birthdateViewModel = TextFieldViewModel(errorMessage: "กรุณากรอกข้อมูลให้ครบถ้วน")
        let emailViewModel = EmailViewModel()

        let brithdate = input.brithdate.bind(to: birthdateViewModel.data)
        commonDispose.append(brithdate)
        
        let email = input.email.bind(to: emailViewModel.data)
        commonDispose.append(email)
        
        let errorValidate = Observable.merge(emailViewModel.errorValue.filter({$0 != nil}),
                                             birthdateViewModel.errorValue.filter({$0 != nil}))

        let forgotPasswordSuccess = input.send
            .filter({ emailViewModel.validateCredentials() && birthdateViewModel.validateCredentials() })
            .map({ _ in (emailViewModel.data.value , birthdateViewModel.data.value ) })
            .flatMapLatest( fecthdata )
        
        return ForgotPasswordViewModel.Output(  forgotPasswordSuccess: forgotPasswordSuccess.filter({ $0 != nil }),
                                                errorValidate: errorValidate,
                                                commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(email:String, brithdate:String) -> Driver<ForgotPassword?> {
        
        guard let loadingScreen = self.loadingScreen else {return .just(nil) }
        
        let forgotPasswordReq = ForgetPasswordReq(email: email,
                                                  birthday: brithdate.DateToNewDateFormat(formatIn: "dd MMMM yyyy", formatOut: "YYYY-MM-dd") ?? "")
        let baseRequestForgotPassword = BaseRequestForgotPassword(forgetPasswordReq: forgotPasswordReq)
        
        let service = GetForgotPasswordApi().callService(request:  baseRequestForgotPassword)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
        .map({  respond -> ForgotPassword? in
            return respond
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: nil)
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

extension ForgotPasswordViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let email: Observable<String>
        let brithdate: Observable<String>
        let send: Observable<Void>
    }
    
    struct Output {
        let forgotPasswordSuccess: Observable<ForgotPassword?>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

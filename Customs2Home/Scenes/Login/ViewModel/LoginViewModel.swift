//
//  LoginViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/6/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import Firebase

class LoginViewModel: BaseViewModel<LoginViewModel>,ViewModelProtocol {

    typealias M = LoginViewModel
    typealias T = LoginViewcontroller
    static var obj_instance: LoginViewModel?

    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        //let item = input.onLoadView.flatMapLatest( fecthdata )
        let emailViewModel = EmailViewModel()
        let passwordViewModel = PasswordViewModel()
        
        let email = input.email.bind(to: emailViewModel.data)
        commonDispose.append(email)
        
        let password = input.password.bind(to: passwordViewModel.data)
        commonDispose.append(password)
        
        let errorValidate = Observable.merge(emailViewModel.errorValue.filter({$0 != nil}) , passwordViewModel.errorValue.filter({$0 != nil}))
        
        let login = input.login
            .filter({ emailViewModel.validateCredentials() && passwordViewModel.validateCredentials() })
            .map({ _ in (emailViewModel.data.value, passwordViewModel.data.value) })
            .flatMapLatest( fecthdata )
        
        let userDetail = login.filter({ $0 }).map({_ in ()})
            .flatMapLatest( getUserDetail )
//            .bind(onNext: { _ in })
        //commonDispose.append(userDetail)
        
        
        return LoginViewModel.Output(   loginSuccess: userDetail.filter({ $0 }),
                                        errorValidate: errorValidate,
                                        commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    func fecthdata(email:String , password:String) -> Observable<Bool> {
        guard let loadingScreen = self.loadingScreen else { return .just((false)) }
        
        let loginReq = LoginReq(userName: email,
                                password: password)
       
        let requestLogin = BaseRequestLogin(loginReq: loginReq)
        
        let service = GetLoginApi().callService(request: requestLogin)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
                guard let k_error = error as? KError else {return false}
                let errorMessage = k_error.getMessage
                let code = " (\(toString( errorMessage.codeString )))"
                self.viewControl?.alert(message: toString( errorMessage.message ) + code)
                return false
            })
            .map({ respond -> Bool in
                self.parser( respond)
                return true
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
    }
    
    func getUserDetail() -> Observable<Bool> {
        return GetUserDetail().callService(request: BaseRequest())
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .map({ respond -> Bool in
                self.parser( respond)
                return true
            })
    }
    
    func parser(_ respond:Login)
    {
        guard let loginResp = respond.loginResp else { return }
        KeyChainService.setAccessToken(AcsToken: loginResp.accessToken ?? "")
        KeyChainService.setRefreshToken(refToken: loginResp.refreshToken ?? "")
    }
    func parser(_ respond:UserDetail)
    {
        guard let userDetailResp = respond.userDetailResp else { return }
        KeyChainService.setEmail(data: userDetailResp.email ?? "")
        KeyChainService.setUserId(data: toString(userDetailResp.userId))
        
        print("loaddd UserDetail")
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension LoginViewModel {
    struct Input {
        let onLoadView: Driver<Void>
        let email: Observable<String>
        let password: Observable<String>
        let login: Observable<Void>
    }
    
    struct Output {
        let loginSuccess: Observable<Bool>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

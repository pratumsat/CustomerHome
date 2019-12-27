//
//  ConfirmEmailViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/19/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ConfirmEmailViewModel: BaseViewModel<ConfirmEmailViewModel>,ViewModelProtocol {

    typealias M = ConfirmEmailViewModel
    typealias T = ConfirmEmailViewController
    static var obj_instance: ConfirmEmailViewModel?
    
    override init() {
        super.init()
    }
    
    var action = "register"
    
    func transform(input: Input) -> Output {
        var commonDispose = [Disposable]()
        let registerResp = input.onLoadView

        let otpViewModel = OTPViewModel()
        let otp = input.otp.bind(to: otpViewModel.data)
        commonDispose.append(otp)

        let resend = input.resendOTP
            .withLatestFrom( registerResp )
            .flatMapLatest( resendOTP )
            .bind { (resp) in
                self.viewControl?.modelBehavior.accept(resp)
                self.viewControl?.textFieldOTP.text = ""
            }
        
        commonDispose.append(resend)
        
        
        
        let getOTP = input.confirmOTP
            .filter({ otpViewModel.validateCredentials() })
            .map({ (otpViewModel.data.value) })
       
        let confirmOTP = getOTP
            .withLatestFrom(registerResp, resultSelector: { ($0, $1) } )
            .flatMapLatest( sendConfirmOTP )
        
        return ConfirmEmailViewModel.Output(confirmOTPSuccess: confirmOTP.filter({ $0 }),
                                            errorValidate: otpViewModel.errorValue.filter({$0 != nil}),
                                            commonDispose: CompositeDisposable(disposables: commonDispose) )
    }

   
    func resendOTP(model:Response_Register?) -> Observable<Response_Register?> {
        guard let loadingScreen = self.loadingScreen else { return .just((nil)) }
        
        
        let generateOtpReq =  GenerateOtpReq(userId: model?.importerRegisterResp?.userId,
                                             action: self.action)
        
        
        let service = GetGenerateOTP().callService(request: BaseRequestGenerateOtp(generateOtpReq: generateOtpReq))
        let loading = loadingScreen.observeLoading(service, shouldRetry: { (error) -> Bool in
                guard let k_error = error as? KError else {return false}
                let errorMessage = k_error.getMessage
                let code = " (\(toString( errorMessage.codeString )))"
                self.viewControl?.alert(message: toString( errorMessage.message ) + code)
                return false
            })
            .map({ respond -> Response_Register? in
                var newModel = model
                newModel?.generateOtpResp = respond.generateOtpResp
                return newModel
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    
    func sendConfirmOTP(otp:String, model:Response_Register? ) -> Observable<Bool> {
        
        guard let loadingScreen = self.loadingScreen else { return .just((false)) }
        
        
        let verifyOtpReq = VerifyOtpReq(userId: model?.importerRegisterResp?.userId,
                                        otp: otp,
                                        otpRef: model?.generateOtpResp?.otpRef,
                                        action: self.action)

        let service = GetVerifyOTP().callService(request: BaseRequestVerifyOTP(verifyOtpReq: verifyOtpReq))
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
    
    
}

extension ConfirmEmailViewModel {
    struct Input {
        let onLoadView: Observable<Response_Register?>
        let otp: Observable<String>
        let resendOTP: Observable<Void>
        let confirmOTP: Observable<Void>
    }
    
    struct Output {
        let confirmOTPSuccess: Observable<Bool>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}

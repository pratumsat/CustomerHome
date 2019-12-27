//
//  ConfirmOTPForgotPasswordViewModel.swift
//  Customs2Home
//
//  Created by thanawat on 11/22/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ConfirmOTPForgotPasswordViewModel: BaseViewModel<ConfirmOTPForgotPasswordViewModel>,ViewModelProtocol {

    typealias M = ConfirmOTPForgotPasswordViewModel
    typealias T = ConfirmOTPForgotPasswordViewController
    static var obj_instance: ConfirmOTPForgotPasswordViewModel?
    
  
    override init() {
        super.init()
    }
    
    var action = "forgetpassword"
    
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
            .withLatestFrom(registerResp, resultSelector: { ($0, $1) })
            .flatMapLatest( sendConfirmOTP )
        
        return ConfirmOTPForgotPasswordViewModel.Output(confirmOTPSuccess: confirmOTP,
                                            errorValidate: otpViewModel.errorValue.filter({$0 != nil}),
                                            commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func resendOTP(model:ForgotPassword?) -> Observable<ForgotPassword?> {
        guard let loadingScreen = self.loadingScreen else { return .just((nil)) }
        
        
        let generateOtpReq =  GenerateOtpReq(userId: model?.forgetPasswordResp?.userId,
                                             action: self.action)
        
        
        let service = GetGenerateOTP().callService(request: BaseRequestGenerateOtp(generateOtpReq: generateOtpReq))
        let loading = loadingScreen.observeLoading(service, shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
            .map({ respond -> ForgotPassword? in
                var newModel = model
                newModel?.generateOtpResp = respond.generateOtpResp
                return newModel
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    
    func sendConfirmOTP(otp:String, model:ForgotPassword? ) -> Observable<(Int, String)?> {
        
        guard let loadingScreen = self.loadingScreen else { return .just((nil)) }
        
        
        let verifyOtpReq = VerifyOtpReq(userId: model?.forgetPasswordResp?.userId,
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
            .map({ respond -> (Int, String)? in
                return (model?.forgetPasswordResp?.userId ?? 0 , model?.generateOtpResp?.otpRef ?? "")
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    
    
}

extension ConfirmOTPForgotPasswordViewModel {
    struct Input {
        let onLoadView: Observable<ForgotPassword?>
        let otp: Observable<String>
        let resendOTP: Observable<Void>
        let confirmOTP: Observable<Void>
    }
    
    struct Output {
        let confirmOTPSuccess: Observable<(Int, String)?>
        let errorValidate: Observable<String?>
        let commonDispose: CompositeDisposable
    }
}


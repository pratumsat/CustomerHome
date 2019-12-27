//
//  ConfirmOTPForgotPasswordViewController.swift
//  Customs2Home
//
//  Created by thanawat on 11/19/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ConfirmOTPForgotPasswordViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    
    @IBOutlet weak var textFieldOTP: UITextField!
    @IBOutlet weak var resendOTPButton: KButton!
    @IBOutlet weak var confirmOTPButton: KButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var otpMessageLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var modelBehavior:BehaviorRelay<ForgotPassword?> =  BehaviorRelay<ForgotPassword?>(value: nil)
    var email:String?
    
    override func viewDidLoad() {
        bind()
        
        self.emailLabel.text = email
        
        textFieldOTP.withImageButton(direction: .Right, image: UIImage(named: "ic_eyeGreen")!, colorSeparator: .clear, colorBorder: .clear, selector: #selector(onTapEye), target: self)
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ConfirmOTPForgotPasswordViewModel.instance()
        viewModel.viewControl = self


        textFieldOTP.rx.text.orEmpty
            .scan("") { (previous, newText) -> String in
                return newText.count <= 6 ? newText : previous
            }
            .bind(onNext: textFieldOTP.setPreservingCursor() )
            .disposed(by: disposeBag)


        modelBehavior.map({ $0?.generateOtpResp?.otpMessage })
            .bind(to: self.otpMessageLabel.rx.text)
            .disposed(by: disposeBag)


        let input = ConfirmOTPForgotPasswordViewModel.Input(onLoadView: modelBehavior.asObservable(),
                                                otp: textFieldOTP.rx.text.orEmpty.asObservable(),
                                                resendOTP: resendOTPButton.rx.tap.asObservable(),
                                                confirmOTP: confirmOTPButton.rx.tap.asObservable())

        let output = viewModel.transform(input: input)

        output.confirmOTPSuccess.bind {[unowned self] (value) in
                self.showRegisterSuccess(value)
            }.disposed(by: disposeBag)

        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
            }.disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
    }
    
    func showRegisterSuccess(_ value:(Int,String)?){
        self.performSegue(withIdentifier: "showSetNewPassword", sender: value)
    }
    
    @objc func onTapEye(){
        textFieldOTP.isSecureTextEntry = !textFieldOTP.isSecureTextEntry
    }
}

extension ConfirmOTPForgotPasswordViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showSetNewPassword" else { return }
        guard let vc = segue.destination as? SetPasswordNav else { return }
        vc.data = sender as? (Int,String)
       
    }
}

extension ConfirmOTPForgotPasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

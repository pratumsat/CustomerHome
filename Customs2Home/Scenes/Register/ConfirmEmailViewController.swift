//
//  ConfirmEmailViewController.swift
//  Customs2Home
//
//  Created by warodom on 12/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ConfirmEmailViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    
    @IBOutlet weak var textFieldOTP: UITextField!
    @IBOutlet weak var resendOTPButton: KButton!
    @IBOutlet weak var confirmOTPButton: KButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var otpMessageLabel: UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    
    
    var modelBehavior:BehaviorRelay<Response_Register?> =  BehaviorRelay<Response_Register?>(value: nil)
    var email:String?
    
    override func viewDidLoad() {
        bind()
        
        self.emailLabel.text = email
        
        textFieldOTP.withImageButton(direction: .Right, image: UIImage(named: "ic_eyeGreen")!, colorSeparator: .clear, colorBorder: .clear, selector: #selector(onTapEye), target: self)
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ConfirmEmailViewModel.instance()
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
        
        
        let input = ConfirmEmailViewModel.Input(onLoadView: modelBehavior.asObservable(),
                                                otp: textFieldOTP.rx.text.orEmpty.asObservable(),
                                                resendOTP: resendOTPButton.rx.tap.asObservable(),
                                                confirmOTP: confirmOTPButton.rx.tap.asObservable())

        let output = viewModel.transform(input: input)
       
        output.confirmOTPSuccess.bind {[unowned self] (value) in
            self.showRegisterSuccess()
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
    }
    
    func showRegisterSuccess(){
        self.performSegue(withIdentifier: "showRegisterSuccess", sender: nil)
    }
    
    @objc func onTapEye(){
        textFieldOTP.isSecureTextEntry = !textFieldOTP.isSecureTextEntry
    }
}

extension ConfirmEmailViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

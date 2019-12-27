//
//  LoginViewcontroller.swift
//  Customs2Home
//
//  Created by warodom on 13/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import Firebase

class LoginViewcontroller: C2HViewcontroller {
    
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var disposeBag : DisposeBag!
    //let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        passwordTextField.withImageButton(direction: .Right, image: UIImage(named: "ic_eye")!, colorSeparator: .clear, colorBorder: .clear, selector: #selector(onTapEye), target: self)

        bind()
    }
    @objc func onTapEye(){
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = LoginViewModel.instance()
        viewModel.viewControl = self
       
        let onload = Driver.just(())
        let input = LoginViewModel.Input(onLoadView: onload,
                                         email: emailTextField.rx.text.orEmpty.asObservable(),
                                         password: passwordTextField.rx.text.orEmpty.asObservable(),
                                         login: loginButton.rx.tap.asObservable())

        let output = viewModel.transform(input: input)
        
        output.loginSuccess.bind {[unowned self] (value) in
            self.performLoginSuccess()
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
    }
  
    
    // Use from back FirstController
    @IBAction func prepareForUnwindToLogin(segue: UIStoryboardSegue) {}
}

extension LoginViewcontroller {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
    
    func performLoginSuccess(){
        self.dismiss(animated: true, completion: nil)
    }
}

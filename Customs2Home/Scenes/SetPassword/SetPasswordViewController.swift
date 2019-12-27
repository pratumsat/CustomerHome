//
//  SetPasswordViewController.swift
//  Customs2Home
//
//  Created by thanawat on 11/11/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class SetPasswordViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var saveButton: KButton!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        passwordTextField.withImageButton(direction: .Right, image: UIImage(named: "ic_eye")!, colorSeparator: .clear, colorBorder: .clear, selector: #selector(tapPassword), target: self )
        confirmPasswordTextField.withImageButton(direction: .Right, image: UIImage(named: "ic_eye")!, colorSeparator: .clear, colorBorder: .clear, selector: #selector(tapcConfirmPassword), target: self )
        
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = SetPasswordViewModel.instance()
        viewModel.viewControl = self
        

        let data = (navigationController as! SetPasswordNav).getData()
        
        let onload = Observable.just((data))
        
        let input = SetPasswordViewModel.Input(onLoadView: onload,
                                               password: passwordTextField.rx.text.orEmpty.asObservable(),
                                               confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
                                               save: saveButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        
        output.setPasswordSuccess.bind {[unowned self] (value) in
            self.showSuccessPage()
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
    }
    func showSuccessPage(){
        self.performSegue(withIdentifier: "showSetPasswordSuccess", sender: nil)
    }
    
    @objc func tapPassword() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    @objc func tapcConfirmPassword() {
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry
    }
    
}
extension SetPasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}


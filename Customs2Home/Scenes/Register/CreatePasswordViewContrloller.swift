//
//  CreatePasswordViewContrloller.swift
//  Customs2Home
//
//  Created by warodom on 11/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class CreatePasswordViewContrloller: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldConfirmPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var registerButton: KButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var importerAddEditReq: ImporterRegisterReq?
//    var imageEye: UIImage = UIImage(named: "ic_eyeGray")
    var imageEye: UIImage! = UIImage(named: "ic_eyeGreen")
    
    
    override func viewDidLoad() {
       
        bind()
        initHeaderView()
        
        
        textfieldPassword.withImageButton(direction: .Right, image: imageEye, colorSeparator: .clear, colorBorder: .clear, selector: #selector(tapPassword), target: self )
        textfieldConfirmPassword.withImageButton(direction: .Right, image: imageEye, colorSeparator: .clear, colorBorder: .clear, selector: #selector(tapcConfirmPassword), target: self )
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = CreatePasswordViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let input = CreatePasswordViewModel.Input(onLoadView: onload,
                                                  email: textfieldEmail.rx.text.orEmpty.asObservable(),
                                                  password: textfieldPassword.rx.text.orEmpty.asObservable(),
                                                  confirmPassword: textfieldConfirmPassword.rx.text.orEmpty.asObservable(),
                                                  register: registerButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        
        output.registerSuccess.bind {[unowned self] (resp) in
            self.showConfirmEmail(resp)
            }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
            }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
    }
    
    func showConfirmEmail(_ resp:Response_Register?){
        self.performSegue(withIdentifier: "showConfirmEmail", sender: resp)
    }
    
    @objc func tapPassword() {
        textfieldPassword.isSecureTextEntry = !textfieldPassword.isSecureTextEntry
        
    }
    @objc func tapcConfirmPassword() {
        textfieldConfirmPassword.isSecureTextEntry = !textfieldConfirmPassword.isSecureTextEntry
    }
    
    func initHeaderView(){
        guard let stepView = UIView.loadNib(name: "StepView")?.first as? StepViewControlller else { return }
        stepView.frame.size = headerView.frame.size
        stepView.view1.backgroundColor = .appThemeColor
        stepView.view2.backgroundColor = .appThemeColor
        stepView.view3.backgroundColor = .appThemeColor
        stepView.lineleft.backgroundColor = .appThemeColor
        stepView.lineRight.backgroundColor = .appThemeColor
        headerView.addSubview(stepView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showConfirmEmail" else { return }
        guard let vc = segue.destination as? ConfirmEmailViewController else { return }
        vc.modelBehavior.accept(sender as? Response_Register ?? nil)
        vc.email = textfieldEmail.text!
    }
}


extension CreatePasswordViewContrloller {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

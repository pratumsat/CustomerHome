//
//  ForgotPasswordViewController.swift
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

class ForgotPasswordViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var sendButton: KButton!
    @IBOutlet weak var brithdateButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var brithdateTextfield: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let datepic = UIDatePicker()
    
    override func viewDidLoad() {
        bind()
        initDatePicker()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ForgotPasswordViewModel.instance()
        viewModel.viewControl = self
        

        let onload = Driver.just(())
        let input = ForgotPasswordViewModel.Input(onLoadView: onload,
                                                  email: emailTextField.rx.text.orEmpty.asObservable(),
                                                  brithdate: brithdateTextfield.rx.text.orEmpty.asObservable(),
                                                  send: sendButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.forgotPasswordSuccess.bind {[unowned self] (resp) in
            self.showVerifyOTP(resp)
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
            }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
    }
    
    @IBAction func onTapCalenda(_ sender: Any) {
        brithdateTextfield.becomeFirstResponder()
    }
    
    func showVerifyOTP(_ resp:ForgotPassword?){
        self.performSegue(withIdentifier: "showVerifyOTP", sender: resp)
    }
    
    func initDatePicker() {
        datepic.datePickerMode = .date
        datepic.locale = .init(identifier: "th_TH")
        datepic.calendar = Calendar(identifier: .buddhist)
        datepic.maximumDate = Date()
        brithdateTextfield.addInputAccessoryView(title: "Done", target: self, selector: #selector(onTapDone))
        brithdateTextfield.inputView = datepic
    }
    
    @objc func onTapDone() {
        brithdateTextfield.text = datepic.date.DateToString(format: "dd MMMM yyyy")
        brithdateTextfield.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showVerifyOTP" else { return }
        guard let vc = segue.destination as? ConfirmOTPForgotPasswordViewController else { return }
        vc.modelBehavior.accept(sender as? ForgotPassword ?? nil)
        vc.email = self.emailTextField.text!
    }
}

extension ForgotPasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

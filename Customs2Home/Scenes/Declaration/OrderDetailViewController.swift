//
//  OrderDetailViewController.swift
//  Customs2Home
//
//  Created by warodom on 13/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class OrderDetailViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var detailViewBottom: UIStackView!
    @IBOutlet weak var detailSW: UISwitch!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let addressObservable:BehaviorSubject<String> =  BehaviorSubject(value: "")
    
    var declareAddEditReq:DeclareAddEditReq?
    
    override func viewDidLoad() {
        //appTitleLabelAndNavigationDelegate(view: self)
        
        
        bind()
        initStepView4(mainView: stepView, label1: .appThemeColor, label2: .borderThemeColor, label3: .borderThemeColor, label4: .borderThemeColor, viewLeft: .borderThemeColor, viewCenter: .borderThemeColor, viewRight: .borderThemeColor)
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = OrderDetailViewModel.instance()
        viewModel.viewControl = self
        
        
        mobileTextField.rx.text.orEmpty
            .scan("") { (previous, newText) -> String in
                return newText.count <= 10 ? newText : previous
            }
            .bind(onNext: mobileTextField.setPreservingCursor() )
            .disposed(by: disposeBag)
        
        addressObservable.filter({ !$0.isEmpty }).bind(to: self.detailLabel.rx.text).disposed(by: disposeBag)
        
        let onload = Observable.just(())
        let input = OrderDetailViewModel.Input(onLoadView: onload,
                                               fullname: fullnameTextField.rx.text.orEmpty.asObservable(),
                                               mobile: mobileTextField.rx.text.orEmpty.asObservable(),
                                               email: emailTextField.rx.text.orEmpty.asObservable(),
                                               address: addressObservable.asObservable(),
                                               toggle : detailSW.rx.isOn.asObservable(), 
                                               nextButton: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.userDetail.bind {[unowned self] (userDetail) in
            guard let userDetailResp = userDetail?.userDetailResp else { return }
            self.nameLabel.text = "\(userDetailResp.firstName ?? "") \(userDetailResp.lastName ?? "")"
            self.addressLabel.text = userDetailResp.address?.fulladdress
            self.mobileLabel.text = userDetailResp.mobileNo
            self.emailLabel.text = userDetailResp.email
            
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
        }.disposed(by: disposeBag)
        
        output.nextStep.bind {[unowned self] (respond) in
            self.showDeclareStep2(data: respond)
        }.disposed(by: disposeBag)
        
        
        output.commonDispose.disposed(by: disposeBag)


        //detailSW.rx.isOn.map({!$0}).bind(to: detailViewBottom.rx.isHidden).disposed(by: disposeBag)
        detailSW.rx.isOn.map({!$0}).bind {[unowned self] (hidden) in
            self.detailViewBottom.isHidden = hidden
        }.disposed(by: disposeBag)
        
        let showAddress = UITapGestureRecognizer(target: self, action: #selector(showAddAddressTapped))
        self.detailLabel.isUserInteractionEnabled = true
        self.detailLabel.addGestureRecognizer(showAddress)
    }
    @objc func showAddAddressTapped(){
        self.performSegue(withIdentifier: "showAddAddress", sender: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            //(self.navigationController as! DeclarationNav).dismissCallback?()
        })
    }
    
    func showDeclareStep2(data:DeclareAddEditReq?){
        self.performSegue(withIdentifier: "showDeclareStep2", sender: data)
    }
}

extension OrderDetailViewController: UINavigationControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showDeclareStep2":
            let vc = segue.destination as! ConfirmBeforeDeclarationViewController
            vc.declareAddEditReq = sender as? DeclareAddEditReq ?? nil
            break
        case "showAddAddress":
            let vc = segue.destination as! AddressViewController
            vc.addressSubject
                .filter({ !$0.isEmpty })
                .bind(to: addressObservable).disposed(by: self.disposeBag!)
            break
       
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Clear Data
//        DeclareSelectProvinceViewModel.instance().provinceSelect.accept(nil)
//        DeclareSelectDistrictViewModel.instance().districtSelect.accept(nil)
//        DeclareSelectSubdistrictViewModel.instance().subDistrictSelect.accept(nil)
//        DeclareSelectPostCodeViewModel.instance().postcodeSelect.accept(nil)

    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if !(viewController is OrderDetailViewController) {
//            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
//        }
//    }
}


//
//  RegisterViewController.swift
//  Customs2Home
//
//  Created by warodom on 5/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class RegisterViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var addAdddressButton: UIButton!
    @IBOutlet weak var stackAddress: UIStackView!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    let datepic = UIDatePicker()
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnProvince: KButton!
    @IBOutlet weak var btnArea: KButton!
    @IBOutlet weak var btnSubdistrict: KButton!
    @IBOutlet weak var btnPostCode: KButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nextButton: KButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBAction func prepareForUnwindToRegister(segue:UIStoryboardSegue){}
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        initDatePicker()
        initHeaderView()
        bind()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isMovingToParent {
            self.addAdddressButton.addDashedBorder()
            //Clear Data
            SelectProvinceViewModel.instance().provinceSelect.accept(nil)
            SelectDistrictViewModel.instance().districtSelect.accept(nil)
            SelectSubdistrictViewModel.instance().subDistrictSelect.accept(nil)
            SelectPostCodeViewModel.instance().postcodeSelect.accept(nil)
        }
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        
        //        SelectProvinceViewModel.instance().provinceSelect.bind(onNext: {[unowned self] data in
        //            self.btnProvince.setTitle(data, for: .normal)
        //        }).disposed(by: disposeBag)
        
        SelectProvinceViewModel.instance().provinceSelect.map({ $0?.0 }).bind(to: btnProvince.rx.title()).disposed(by: disposeBag)
        SelectDistrictViewModel.instance().districtSelect.map({ $0?.0 }).bind(to: btnArea.rx.title()).disposed(by: disposeBag)
        SelectDistrictViewModel.instance().districtSelect.map({$0 != nil}).bind(to: btnArea.rx.isEnabled).disposed(by: disposeBag)
        SelectSubdistrictViewModel.instance().subDistrictSelect.map({ $0?.0 }).bind(to: btnSubdistrict.rx.title()).disposed(by: disposeBag)
        SelectSubdistrictViewModel.instance().subDistrictSelect.map({$0 != nil}).bind(to: btnSubdistrict.rx.isEnabled).disposed(by: disposeBag)
        SelectPostCodeViewModel.instance().postcodeSelect.map({ $0?.0 }).bind(to: btnPostCode.rx.title()).disposed(by: disposeBag)
        SelectPostCodeViewModel.instance().postcodeSelect.map({$0 != nil}).bind(to: btnPostCode.rx.isEnabled).disposed(by: disposeBag)
        
        
        
        let viewModel = RegisterViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        
        mobileTextField.rx.text.orEmpty
            .scan("") { (previous, newText) -> String in
                return newText.count <= 10 ? newText : previous
            }
            .bind(onNext: mobileTextField.setPreservingCursor() )
            .disposed(by: disposeBag)
        
        let address = Observable.combineLatest(
                                            addressTextField.rx.text.orEmpty.asObservable(),
                                            SelectProvinceViewModel.instance().provinceSelect.asObservable(),
                                            SelectDistrictViewModel.instance().districtSelect.asObservable(),
                                            SelectSubdistrictViewModel.instance().subDistrictSelect.asObservable(),
                                            SelectPostCodeViewModel.instance().postcodeSelect.asObservable(),
                                            resultSelector: { (address, province, area, district, postcode) -> Bool in
                                                return (!address.isEmpty)
                                                        && (province != nil ? true : false)
                                                        && (area != nil ? true : false)
                                                        && (district != nil ? true : false)
                                                        && (postcode != nil ? true : false)
                                            }).map({ $0 ? "fill" : ""})
        
        
        let input = RegisterViewModel.Input(onLoadView: onload,
                                            firstName: firstNameTextField.rx.text.orEmpty.asObservable(),
                                            lastName: lastNameTextField.rx.text.orEmpty.asObservable(),
                                            brithdate: dateOfBirthTextField.rx.text.orEmpty.asObservable(),
                                            mobile: mobileTextField.rx.text.orEmpty.asObservable(),
                                            address: address,
                                            nextTapped: nextButton.rx.tap.asObservable())
    
        let output = viewModel.transform(input: input)
        
        output.validate.bind {[unowned self] (value) in
            self.performSegue(withIdentifier: "showCreatePassword", sender: nil)
        }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
        
        //        datepic.rx.controlEvent(.valueChanged).bind(onNext: { [unowned self] in
        //            let dateFormat = DateFormatter()
        //            //        dateFormat.dateStyle = .medium
        //            dateFormat.dateFormat = "dd-MM-YYYY"
        //            dateFormat.locale = Locale(identifier: "th_TH")
        //            self.dateOfBirthTextField.text = dateFormat.string(from: self.datepic.date)
        //        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreatePasswordViewContrloller {
            let destination = segue.destination as! CreatePasswordViewContrloller
            let importerAddEditReq = ImporterRegisterReq(firstNameTH: firstNameTextField.text ?? "", lastNameTH: lastNameTextField.text ?? "", mobileNo: mobileTextField.text ?? "", birthday: dateOfBirthTextField.text?.DateToNewDateFormat(formatIn: "dd MMMM yyyy", formatOut: "YYYY-MM-dd") ?? "", address: addressTextField.text ?? "", province: SelectProvinceViewModel.instance().provinceSelect.value?.1 ?? "", district: SelectDistrictViewModel.instance().districtSelect.value?.1 ?? "", subDistrict: SelectSubdistrictViewModel.instance().subDistrictSelect.value?.1 ?? "", zipCode: btnPostCode.titleLabel?.text ?? "")
            destination.importerAddEditReq = importerAddEditReq   
        }
        
        
        switch segue.identifier {
        case "editDistrict":
            let distination = segue.destination as! SelectDistrictViewController
            distination.provinceCode = SelectProvinceViewModel.instance().provinceSelect.value?.1 ?? ""
            break
        case "editSubDistrict":
            let distination = segue.destination as! SelectSubdistrictViewController
            distination.districtCode = SelectDistrictViewModel.instance().districtSelect.value?.1 ?? ""
            break
        case "editPostCode":
            let distination = segue.destination as! SelectPostCodeViewController
            distination.zipCode = SelectSubdistrictViewModel.instance().subDistrictSelect.value?.1 ?? ""
            break
        default:
            break
        }
    }
    
    func onRegistor(){
         self.performSegue(withIdentifier: "showCreatePassword", sender: self)
    }
    
    
    func initHeaderView(){
        guard let stepView = UIView.loadNib(name: "StepView")?.first as? StepViewControlller else { return }
        stepView.frame.size = headerView.frame.size
        stepView.view1.backgroundColor = .appThemeColor
        stepView.view2.backgroundColor = .appThemeColor
        stepView.view3.backgroundColor = .borderThemeColor
        stepView.lineleft.backgroundColor = .appThemeColor
        stepView.lineRight.backgroundColor = .borderThemeColor
        headerView.addSubview(stepView)
        
    }
    
    @IBAction func onAddAdddress(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            sender.layer.sublayers?.filter({ $0 is CAShapeLayer }).forEach({ $0.removeFromSuperlayer() })
            sender.setTitle("ข้อมูลที่อยู่", for: .normal)
            sender.isEnabled = false
            self.stackAddress.isHidden = false
        })
    }
    
    @IBAction func onTapCalenda(_ sender: Any) {
        dateOfBirthTextField.becomeFirstResponder()
    }
    
    
    func initDatePicker() {
        datepic.datePickerMode = .date
        datepic.locale = .init(identifier: "th_TH")
        datepic.calendar = Calendar(identifier: .buddhist)
        datepic.maximumDate = Date()
        dateOfBirthTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(onTapDone))
        dateOfBirthTextField.inputView = datepic
    }
    
    @objc func onTapDone() {
        dateOfBirthTextField.text = datepic.date.DateToString(format: "dd MMMM yyyy")
        dateOfBirthTextField.resignFirstResponder()
    }
}

extension RegisterViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

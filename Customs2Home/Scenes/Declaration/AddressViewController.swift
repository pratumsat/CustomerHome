//
//  AddressViewController.swift
//  Customs2Home
//
//  Created by warodom on 3/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class AddressViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBAction func prepareForUnwindToAddress(segue: UIStoryboardSegue) {}
  
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var textFieldProvince: UIButton!
    @IBOutlet weak var textFieldDistrict: UIButton!
    @IBOutlet weak var textFieldSubDistrict: UIButton!
    @IBOutlet weak var textFieldPostcode: UIButton!
   
    @IBOutlet weak var addressTextField:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    let addressSubject:BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override func viewDidLoad() {
        bind()
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = AddressViewModel.instance()
        viewModel.viewControl = self
       
        AddressViewModel.instance().addressRelay.bind(to: addressTextField.rx.text).disposed(by: disposeBag)

        
        DeclareSelectProvinceViewModel.instance().provinceSelect.map({ $0?.0 }).bind(to: textFieldProvince.rx.title(for: .normal)).disposed(by: disposeBag)
        DeclareSelectDistrictViewModel.instance().districtSelect.map({$0?.0}).bind(to: textFieldDistrict.rx.title(for: .normal)).disposed(by: disposeBag)
        
        DeclareSelectDistrictViewModel.instance().districtSelect.map({$0 != nil}).bind(to: textFieldDistrict.rx.isEnabled).disposed(by: disposeBag)
        
        DeclareSelectSubdistrictViewModel.instance().subDistrictSelect.map({$0?.0}).bind(to: textFieldSubDistrict.rx.title(for: .normal)).disposed(by: disposeBag)
         DeclareSelectSubdistrictViewModel.instance().subDistrictSelect.map({$0 != nil}).bind(to: textFieldSubDistrict.rx.isEnabled).disposed(by: disposeBag)
        
        DeclareSelectPostCodeViewModel.instance().postcodeSelect.map({$0?.0}).bind(to: textFieldPostcode.rx.title(for: .normal)).disposed(by: disposeBag)
        
        DeclareSelectPostCodeViewModel.instance().postcodeSelect.map({$0 != nil}).bind(to: textFieldPostcode.rx.isEnabled).disposed(by: disposeBag)
        
        let address = Observable.combineLatest(
            addressTextField.rx.text.orEmpty.asObservable(),
            DeclareSelectProvinceViewModel.instance().provinceSelect.asObservable(),
            DeclareSelectDistrictViewModel.instance().districtSelect.asObservable(),
            DeclareSelectSubdistrictViewModel.instance().subDistrictSelect.asObservable(),
            DeclareSelectPostCodeViewModel.instance().postcodeSelect.asObservable(),
            resultSelector: { (address, province, area, district, postcode) -> Bool in
                return (!address.isEmpty)
                    && (province != nil ? true : false)
                    && (area != nil ? true : false)
                    && (district != nil ? true : false)
                    && (postcode != nil ? true : false)
        }).map({ $0 ? "fill" : ""})
        
        let input = AddressViewModel.Input(address: address,
                                           confirmTapped: confirmButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.validate.bind {[unowned self] (fulladdress) in
            self.addressSubject.onNext(fulladdress)
            self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.alert(message: messageError!)
            }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "editDeclareDistrict":
            let distination = segue.destination as! DeclareSelectDistrictViewController
            distination.provinceCode = DeclareSelectProvinceViewModel.instance().provinceSelect.value?.1 ?? ""
            break
        case "editDeclareSubDistrict":
            let distination = segue.destination as! DeclareSelectSubdistrictViewController
            distination.districtCode = DeclareSelectDistrictViewModel.instance().districtSelect.value?.1 ?? ""
            break
        case "editDeclarePostCode":
            let distination = segue.destination as! DeclareSelectPostCodeViewController
            distination.zipCode = DeclareSelectSubdistrictViewModel.instance().subDistrictSelect.value?.1 ?? ""
            break
        default:
            break
        }
    }
    
}


extension AddressViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

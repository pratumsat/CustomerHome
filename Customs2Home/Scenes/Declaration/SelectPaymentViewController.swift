//
//  SelectPaymentViewController.swift
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
import RadioGroup


class SelectPaymentViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var radioGroup: RadioGroup!
    @IBOutlet weak var declareButton: UIButton!
    @IBAction func prepareForUnwindToSelectPaymentView(segue:UIStoryboardSegue){}
    
    var declareId:String?
    
    var selectPaymentSubject:BehaviorSubject<Int?> = BehaviorSubject(value: nil)
    
    
    override func viewDidLoad() {
        appTitleLabelAndNavigationDelegate(view: self)
        
        
        if let paymanentNav = navigationController as? PaymentNav {
            self.declareId = paymanentNav.declareId

            if !paymanentNav.fromTab {
                performSegue(withIdentifier: "showDeclareBox", sender: nil)
            }
            
            if let payment_method = paymanentNav.payment_method {
                switch payment_method{
                case "QR_CODE":
                    radioGroup.selectedIndex = 0
                    selectPaymentSubject.onNext(0)
                    break
                case "CREDIT_CARD" , "DEBIT_CARD":
                    radioGroup.selectedIndex = 1
                    selectPaymentSubject.onNext(1)
                    break
                case "BILL_PAYMENT":
                    radioGroup.selectedIndex = 2
                    selectPaymentSubject.onNext(2)
                    break
                default:
                    break
                }
            }
        }
      
        bind()
        
        initRadio()
      
    }
    
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = SelectPaymentViewModel.instance()
        viewModel.viewControl = self
        
        let onload = Driver.just(())

        let selectPayment = selectPaymentSubject.filter({ $0 != nil }).map({ $0! })
        
        selectPaymentSubject.map({ $0 != nil })
            .bind(to: declareButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let input  = SelectPaymentViewModel.Input(onLoadView: onload,
                                                  declareId: Observable.just(declareId),
                                                  selectPayment: selectPayment.asObservable(),
                                                  addDeclare: declareButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.declareSuccess.bind {[unowned self] (paymentType) in
            guard let paymentType = paymentType else { return }
            switch paymentType {
            case .QR_CODE(let declareId ):
                self.showQRcode(declareId)
                break
            case .CREDIT_CARD(let declareId ):
                self.showPayment(declareId)
                break
            case .BILL_PAYMENT(let declareId ):
                self.showBillPay(declareId)
                break
            }
        }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)

    }
    
    func initRadio() {
        let attributedString = NSMutableAttributedString(string: "ชำระด้วย คิวอาร์โค๊ด (QR Code)\nแสกนจ่ายทันทีด้วย โมบายแบงกิ้ง เท่านั้น\n")
        attributedString.addAttributes([.foregroundColor: UIColor.appThemeColor], range: NSRange(location: 0, length: 30))
        attributedString.addAttributes([.font:UIFont.mainFontRegular(ofSize: 14)], range: NSRange(location: 0, length: 30))
        attributedString.addAttributes([.foregroundColor: UIColor.borderThemeColor], range: NSRange(location: 31, length: 39))
        attributedString.addAttributes([.font:UIFont.mainFontRegular(ofSize: 12)], range: NSRange(location: 31, length: 39))
        
        let attributedString_1 = NSMutableAttributedString(string: "ชำระด้วย บัตรเครดิตออนไลน์\nระบุบัตรเครดิตเพื่อชำระเงินทันที\n")
        attributedString_1.addAttributes([.foregroundColor: UIColor.appThemeColor], range: NSRange(location: 0, length: 26))
        attributedString_1.addAttributes([.foregroundColor: UIColor.borderThemeColor], range: NSRange(location: 27, length: 32))
        attributedString_1.addAttributes([.font:UIFont.mainFontRegular(ofSize: 14)], range: NSRange(location: 0, length: 26))
        attributedString_1.addAttributes([.font:UIFont.mainFontRegular(ofSize: 12)], range: NSRange(location: 27, length: 32))
        
        let attributedString_2 = NSMutableAttributedString(string: "ชำระด้วย ใบแจ้งชำระเงิน\nออกใบ Pay-in เพื่อชำระผ่านช่องทางต่าง ๆ ของธนาคาร\n")
        attributedString_2.addAttributes([.foregroundColor: UIColor.appThemeColor], range: NSRange(location: 0, length: 23))
        attributedString_2.addAttributes([.foregroundColor: UIColor.borderThemeColor], range: NSRange(location: 24, length: 49))
        attributedString_2.addAttributes([.font:UIFont.mainFontRegular(ofSize: 14)], range: NSRange(location: 0, length: 23))
        attributedString_2.addAttributes([.font:UIFont.mainFontRegular(ofSize: 12)], range: NSRange(location: 24, length: 49))
        
        radioGroup.attributedTitles = [
            attributedString,attributedString_1,attributedString_2  ]
    }
    
    
    @IBAction func onSelectRadio(_ sender: RadioGroup) {
        self.selectPaymentSubject.onNext(sender.selectedIndex)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let paymentnav = self.navigationController as? PaymentNav {
                paymentnav.dismissCallback?()
            }
        })
    }
}

extension SelectPaymentViewController:UINavigationControllerDelegate {
    func showQRcode(_ declareId:Int){
        performSegue(withIdentifier: "showQRcode", sender: declareId)
    }
    func showPayment(_ declareId:Int){
        performSegue(withIdentifier: "showPayment", sender: declareId)
    }
    func showBillPay(_ declareId:Int){
        performSegue(withIdentifier: "showBillPay", sender: declareId)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showQRcode":
            let vc = segue.destination as! ScanQrViewController
            vc.declareId = (sender as! Int)
            
            break
        case "showPayment":
            let vc = segue.destination as! PaymentCardViewController
            vc.declareId = (sender as! Int)
            
            break
        case "showBillPay":
            let vc = segue.destination as! BillPaymentViewController
            vc.declareId = (sender as! Int)
            
            break
            
        default:
            break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is SelectPaymentViewController) {
            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
        }
    }
}

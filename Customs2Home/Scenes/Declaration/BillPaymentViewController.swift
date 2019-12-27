//
//  BillPaymentViewController.swift
//  Customs2Home
//
//  Created by thanawat on 12/11/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class BillPaymentViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailLabel: PaddingLabel!
    
    var declareId:Int = 0
    
    override func viewDidLoad() {
        
        bind()
    }
    func bind()  {
        var email:String?
        if let paymanentNav = navigationController as? PaymentNav {
            email = paymanentNav.email
        }

        emailLabel.text = email
        
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = BillPaymentViewModel.instance()
        viewModel.viewControl = self
        let onload = sendButton.rx.tap.asDriver().map({ [unowned self] _ -> Int in
            return self.declareId
        }) //Driver.just((declareId))
        let input = BillPaymentViewModel.Input( onLoadView: onload)

        let output = viewModel.transform(input: input)
        output.items?.map({ [unowned self] _ in
            return self.printna()
        }).drive().disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
    }
    
    func printna() {
        self.alert(message: "กรุณาตรวจสอบอีเมลล์ของท่าน", title: "ส่งอีเมลล์สำเร็จ" )
    }
    
   
}

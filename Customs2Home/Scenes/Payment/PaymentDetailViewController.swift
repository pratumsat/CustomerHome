//
//  PaymentDetailViewController.swift
//  Customs2Home
//
//  Created by thanawat on 12/17/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class PaymentDetailViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    var declareId: String?{
        didSet{
            printRed("declareId \(declareId)")
        }
    }
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = PaymenyDetailViewModel.instance()
        viewModel.viewControl = self
       
        
        
        let onload = Observable.just(toInt(declareId))

        let input = PaymenyDetailViewModel.Input( onLoadView: onload )

        let output = viewModel.transform(input: input)
        
        output.declareDetail.bind { (declareResponse) in
            guard let declareResponse = declareResponse else { return }
            //updateUI()
        }.disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
    }
}

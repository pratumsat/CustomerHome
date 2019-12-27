//
//  AlertUpdateCurrencyViewController.swift
//  Customs2Home
//
//  Created by thanawat on 11/29/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class AlertUpdateCurrencyViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        monthLabel.text = "ณ \(Date().DateToString(format: "MMMM yyyy"))"
        bind()
    }
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func bind()  {
//        self.disposeBag = DisposeBag()
//        let disposeBag = self.disposeBag!
//        let viewModel = <#ViewModelName#>.instance()
//        viewModel.viewControl = self
//        let onload = Driver.just(())
//
//        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
//            try?self.tableView.rx.model(at: path)
//        }).asDriver(onErrorJustReturn: nil)
//        let input = <#ViewModelName#>.Input( onLoadView: onload,
//                                                  onItem: onItem )
//
//        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
//        output.commonDispose.disposed(by: disposeBag)
    }
  
}

//
//  LoginRegisterViewController.swift
//  Customs2Home
//
//  Created by thanawat on 12/19/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class LoginRegisterViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        bind()
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
//        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
//        output.commonDispose.disposed(by: disposeBag)
    }
    
//    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
//        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
//            cell.bind(cellData: cellModel)
//            return cell
//    })
}

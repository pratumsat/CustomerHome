//
//  ContactViewController.swift
//  Customs2Home
//
//  Created by warodom on 11/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ContactViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
//    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textField: UILabel!
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ContactViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

//        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
//            try?self.tableView.rx.model(at: path)
//        }).asDriver(onErrorJustReturn: nil)
        let input = ContactViewModel.Input( onLoadView: onload,
                                                  onItem: nil )
        
        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
}

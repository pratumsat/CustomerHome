//
//  CurrencyViewController.swift
//  Customs2Home
//
//  Created by warodom on 24/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class CurrencyViewController: C2HViewcontroller {
    var disposeBag: DisposeBag?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnNext: UIButton!

    override func viewDidLoad() {
        bind()
    }
    
    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = CurrencyViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
//        let onselect = tableView.rx.itemSelected.map({ [unowned self] index -> ExchangeRateList? in
//
//
//
//            let rate = ExchangeRateList()
//            return rate
//        }).asDriver(onErrorJustReturn: nil)
        let input = CurrencyViewModel.Input(onLoadView: onload,
                                            onItem: onItem)

        let output = viewModel.transform(input: input)
        output.items?.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)

//        tableView.rx.itemSelected.asDriver().do(onNext: { [unowned self] index in
//            printRed(index)
//            let cell = self.tableView.cellForRow(at: index)
//            cell?.accessoryType = .checkmark
//            self.checkSelect()
//        })
//        .drive().disposed(by: disposeBag)

        tableView.rx.modelDeselected(KTableCellModel.self).asDriver().do(onNext: { model in
            model.onCellCheck.accept(false)
        }).drive().disposed(by: disposeBag)

        viewModel.selectExchange.bind(onNext: { [unowned self] value in
            self.btnNext.isEnabled = (value != nil)
        }).disposed(by: disposeBag)

//        tableView.rx.itemDeselected.asDriver().do(onNext: { [unowned self] index in
//            printGreen(index)
//            let model:KTableCellModel? = try? self.tableView.rx.model(at: index)
//            model?.onCellCheck.accept(false)
        ////            let cell = self.tableView.cellForRow(at: index)
        ////            cell?.accessoryType = .none
        ////            self.checkSelect()
//        })
//            .drive().disposed(by: disposeBag)
    }

//    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
//        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
//            cell.bind(cellData: cellModel)
//            return cell
//    })
    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, _, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)

            cellModel.onCellCheck.bind(onNext: { value in
                cell.accessoryType = value ? .checkmark : .none
            }).disposed(by: cell.disposeBag!)

            return cell
        })
        datasource.canEditRowAtIndexPath = { _, _ in
            true
        }
        return datasource
    }()

//    func checkSelect() {
//        guard let array = tableView.indexPathsForSelectedRows else {
//            btnNext.isEnabled = false
//            return
//        }
//        btnNext.isEnabled = array.count > 0
//    }
}




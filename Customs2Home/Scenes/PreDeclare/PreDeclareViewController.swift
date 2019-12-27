//
//  PreDeclareViewController.swift
//  Customs2Home
//
//  Created by Wittawas Mukdaprasert on 2/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class PreDeclareViewController: C2HViewcontroller {
    var disposeBag: DisposeBag?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var taxButton: UIButton!

    var showTaxButton: PublishSubject<IndexPath> = PublishSubject()

    override func viewDidLoad() {
//        self.tableView.delegate = self
        bind()
        //        let backItem = UIBarButtonItem()
        //        backItem.title = "หมวดหมู่หลัก"
        //        navigationItem.backBarButtonItem = backItem
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: editButtonItem.action)

        navigationItem.rightBarButtonItems?.append(button)
    }

//    override func viewWillAppear(_ animated: Bool)  {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = PreDeclareViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())
        //        let onload = self.rx.viewDidAppear.map({ _ in }).asDriver(onErrorJustReturn: ())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        let input = PreDeclareViewModel.Input(onLoadView: onload,
                                              onItem: onItem,
//                                               onTaxButton:  self.taxButton.rx.tap.asDriver(),
                                              onShowTax: showTaxButton.asDriver(onErrorJustReturn: IndexPath()))

        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] _ in
                self.updateHeader()
            })
            .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }

    func updateHeader() {
        guard let header = self.tableView.tableHeaderView else { return }
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        header.height = height
    }

    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)

            let tax = cell.button1?.rx.tap.map({ _ in indexPath })
            tax?.bind(to: self.showTaxButton).disposed(by: cell.disposeBag!)
            return cell
        })
        datasource.canEditRowAtIndexPath = { _, _ in
            true
        }
        return datasource
    }()

    func onTaxForm() {
        performSegue(withIdentifier: "showTaxForm", sender: nil)
    }

    func onListItem() {
        performSegue(withIdentifier: "openListItem", sender: nil)
    }
}

extension PreDeclareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let header = UIView.loadNib(name: "HeaderviewPreDeclare")?.first

        return header
    }
}

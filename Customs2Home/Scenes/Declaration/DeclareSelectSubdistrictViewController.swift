//
//  DeclareSelectSubdistrictViewController.swift
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

class DeclareSelectSubdistrictViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    var districtCode: String = ""
    var zipCode: String = ""
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = DeclareSelectSubdistrictViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just((districtCode))
        
        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        let input = DeclareSelectSubdistrictViewModel.Input( onLoadView: onload,
                                                      onItem: onItem )
        
        let output = viewModel.transform(input: input)
        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        tableView.rx.modelDeselected(KTableCellModel.self).asDriver().do(onNext: { model in
            model.onCellCheck.accept(false)
        }).drive().disposed(by: disposeBag)
        viewModel.zipCode.bind(onNext: { [unowned self] in self.zipCode = $0 ?? ""}).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DeclareSelectPostCodeViewController {
            let des = segue.destination as! DeclareSelectPostCodeViewController
            des.zipCode = self.zipCode
        }
    }
    
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
    func onPostcode() {
        self.performSegue(withIdentifier: "detopostcode", sender: self)
    }

}

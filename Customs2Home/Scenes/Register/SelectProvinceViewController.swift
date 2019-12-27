//
//  SelectProvinceViewController.swift
//  Customs2Home
//
//  Created by warodom on 12/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class SelectProvinceViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    var provinceCode: String?
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = SelectProvinceViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        let input = SelectProvinceViewModel.Input( onLoadView: onload,
                                                  onItem: onItem )
        
        let output = viewModel.transform(input: input)
        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        tableView.rx.modelDeselected(KTableCellModel.self).asDriver().do(onNext: { model in
            model.onCellCheck.accept(false)
        }).drive().disposed(by: disposeBag)
        
        viewModel.provinceSelect.bind(onNext: { [unowned self] in self.provinceCode = $0?.1 }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SelectDistrictViewController {
            let des = segue.destination as! SelectDistrictViewController
            des.provinceCode = self.provinceCode ?? ""
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
    func onArea(){
        self.performSegue(withIdentifier: "toarea", sender: self)
    }
}

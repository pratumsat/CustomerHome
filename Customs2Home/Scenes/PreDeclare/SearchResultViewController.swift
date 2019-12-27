//
//  SearchResultViewController.swift
//  Customs2Home
//
//  Created by warodom on 27/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class SearchResultViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = SearchResultViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        let input = SearchResultViewModel.Input( onLoadView: onload,
                                                  onItem: onItem )
        
        let output = viewModel.transform(input: input)
        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
     
        tableView.rx.modelSelected( KTableCellModel.self ).asDriver().do(onNext: { model in
            
            let tariffList = model.content as! TariffList
            
//            let catModel = CategoryCellModel.init(tariffList)
//            catModel.identity = toInt( tariffList.categoryID )
//            catModel.name = tariffList.categoryName
//
//            let subCatModel = CategoryCellModel.init(tariffList)
//            subCatModel.identity = toInt( tariffList.subCategoryID )
//            subCatModel.name = tariffList.subCategory
//
//            let tariffModel = CategoryCellModel.init(tariffList)
            
            if let categoryViewControl = CategoryViewModel.instance().viewControl {
                categoryViewControl.didSelect.onNext( tariffList )
                categoryViewControl.didSelect.onCompleted()
            }
            
        }).drive().disposed(by: disposeBag)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.registKeyboardNotification()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.resignKeyboardNotification()
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
}

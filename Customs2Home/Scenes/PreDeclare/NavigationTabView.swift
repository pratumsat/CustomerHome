//
//  NavigationTabView.swift
//  Customs2Home
//
//  Created by warodom on 10/10/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class NavigationTabView: UIViewController {
    
    var disposeBag :DisposeBag?
    var items = BehaviorRelay<[KTableCellSection]> (value: [])
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        items.bind(to:  self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag)
        self.tableView.rx.itemSelected.bind(onNext: { [unowned self] (path) -> Void in
            if let model:KTableCellModel = try? self.tableView.rx.model(at: path) {
                self.onSelectCell(model: model)
            }
        }).disposed(by: disposeBag)
    }
    
    func onSelectCell( model:KTableCellModel )
    {
         let navigationtabView = self.loadStory(identifier: "navigationtabView") as! NavigationTabView
         if let data = model.cellBuildDetail as? [KTableCellModel] {
            self.navigationController?.pushViewController(navigationtabView, animated: true)
            navigationtabView.items.accept( [ KTableCellSection(identity: 0, items: data) ] )
            if let categoryViewControl = CategoryViewModel.instance().viewControl {
                categoryViewControl.navigatorSelect.onNext( model as! CategoryCellModel )
            }
            guard let navItems = self.navigationController?.viewControllers.count else { return }
            CategoryViewModel.instance().viewControl?.segmentedControl.setSelectedSegmentIndex((navItems - 1), animated: true)
        }
        else {
            if let categoryViewControl = CategoryViewModel.instance().viewControl {
                categoryViewControl.navigatorSelect.onNext( model as! CategoryCellModel )
                categoryViewControl.navigatorSelect.onCompleted()
            }
        }
        
        
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
}

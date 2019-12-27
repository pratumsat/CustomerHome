//
//  AlertViewController.swift
//  Customs2Home
//
//  Created by thanawat on 11/13/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import Refreshable

class AlertViewController: C2HViewcontroller {
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var noItemLabel: UILabel!
    
    var tableViewEditing = BehaviorRelay<Bool>(value: false)
    
    var onRefreshBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    var onLoadMoreBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    
    
    override func viewDidLoad() {
        appTitleLabelAndNavigationDelegate(view: self) 
        bind()
        addPullRefresh()
    }
    
    func updateLoadMoreEnable(_ count:Int) {
        tableView.setLoadMoreEnable(count != 0)
    }
    
    func addPullRefresh(){
        tableView.addPullToRefresh(action: {  [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.onRefreshBehavior.onNext(())
            }
        })
        
        tableView.addLoadMore(action: {  [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.onLoadMoreBehavior.onNext(())
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteBarButton.action = editButtonItem.action
        self.onRefreshBehavior.onNext(())
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableViewEditing.accept(!tableViewEditing.value)
        
        if tableViewEditing.value {
            deleteBarButton.image = nil
            deleteBarButton.title = "ยกเลิก"
            
        } else {
            deleteBarButton.image = UIImage(named: "icnDelete")
        }
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = AlertViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected
            .filter({ [unowned self] _ in !self.tableView.isEditing })
            .map({ [unowned self] path -> KTableCellModel? in
                try?self.tableView.rx.model(at: path)
            }).asDriver(onErrorJustReturn: nil)
        
        
        
        let onDelete = deleteButton.rx.tap
            .asDriver()
            .filter({ [unowned self] in
                if self.tableView.indexPathsForSelectedRows == nil {
                    self.alert(message: "ต้องเลือกอย่างน้อย 1 ชิ้น เพื่อทำการลบรายการ")
                }
                return self.tableView.indexPathsForSelectedRows != nil
            }).map({ [unowned self] _ -> [KTableCellModel]? in
                self.tableView.indexPathsForSelectedRows?.map({ [unowned self] indexpath -> KTableCellModel in
                    try! self.tableView.rx.model(at: indexpath) as KTableCellModel
                })
            })
        
        let onLoadMore = onLoadMoreBehavior.filter({ $0 != nil }).asDriver(onErrorJustReturn: nil)
        let onRefresh = onRefreshBehavior.filter({ $0 != nil }).asDriver(onErrorJustReturn: nil)
        
        let input = AlertViewModel.Input( onLoadView: onload,
                                          onRefresh: onRefresh,
                                          onLoadMore: onLoadMore,
                                          onItem: onItem,
                                          onDelete: onDelete )
        
        let output = viewModel.transform(input: input)
        
        output.items?
            .do(onNext: { [unowned self] item in
                self.noItemLabel.isHidden = !item.isEmpty
                
                self.deleteBarButton.title = nil
                self.deleteBarButton.image = UIImage(named: "icnDelete")
                
                self.tableView.setEditing(false, animated: true)
                self.deleteButton.isHidden = true
                
                self.deleteBarButton.isEnabled =  !item.isEmpty
               
                
                if !item.isEmpty {
                    self.tableViewEditing.accept(false)
                }
                self.setMarginFooter()
            }).drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        
        output.onItemSelect.bind {[unowned self] (msgId) in
            guard let msgId = msgId else { return }
            self.showAlertDetail(msgId)
            
            }.disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
        
        tableViewEditing.bind(onNext: { value in
            self.tableView.setEditing(value, animated: true)
            self.deleteButton.isHidden = !value
        }).disposed(by: disposeBag)
    }
    
    func setMarginFooter() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, _, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            
            cellModel.readFlag?.bind(onNext: { (read) in
                cell.subView?.backgroundColor = read ? .pale_grey_two2 : .white
            }).disposed(by: self.disposeBag!)
            
            self.tableViewEditing.bind(onNext: { value in
                cell.selectionStyle = value ? .default : .none
            }).disposed(by: self.disposeBag!)
            
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
    
}


extension AlertViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is AlertViewController) {
            viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
        }
    }
    func showAlertDetail(_ msgId: Int){
        performSegue(withIdentifier: "showAlertDetail", sender: msgId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showAlertDetail" else { return }
        guard let vc = segue.destination as? AlertDetailViewController else { return }
        vc.msgId = (sender as! Int)
    }
}

//
//  TabDeclarationViewController.swift
//  Customs2Home
//
//  Created by warodom on 28/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import SWSegmentedControl
import Refreshable

class TabDeclarationViewController: UIViewController, UINavigationControllerDelegate, SWSegmentedControlDelegate {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var segmentControl: SWSegmentedControl!
    @IBAction func prepareForUnwindToHomeDeclare(segue: UIStoryboardSegue) {}
    var segmentIndex = BehaviorRelay<Int>(value: 0)
    
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
     var tableViewEditing = BehaviorRelay<Bool>(value: false)

    
    var bool : Bool = true
    var beginVc = false
    
    var onRefreshBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    var onLoadMoreBehavior:BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    
    override func viewDidLoad() {
        bind()
        appTitleLabelAndNavigationDelegate(view: self)
        segmentControl.delegate = self
        segmentControl.items = ["รอการชำระเงิน","เกินกำหนดชำระเงิน"]
        segmentControl.font = UIFont.mainFontRegular(ofSize: 12)
        btnDelete.action = editButtonItem.action

        
        addPullRefresh()
    }
    
    fileprivate func refreshData(){
        self.onRefreshBehavior.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !beginVc {
            beginVc = true
        }else{
            refreshData()
        }
        
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
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = TabDeclarationViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected
            .filter({ [unowned self] _ in !self.tableView.isEditing })
            .map({ [unowned self] path -> KTableCellModel? in
                try?self.tableView.rx.model(at: path)
            })
            .asDriver(onErrorJustReturn: nil)
     
        
        let onSecment = segmentIndex.asDriver()
        
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
    
        let input = TabDeclarationViewModel.Input( onLoadView: onload,
                                                   onRefresh: onRefresh,
                                                   onLoadMore: onLoadMore,
                                                   onItem: onItem,
                                                   onSegment: onSecment,
                                                   onDelete : onDelete)
        
        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] item in
                self.noItemLabel.isHidden = !item.isEmpty
                self.btnDelete.isEnabled = self.segmentControl.selectedSegmentIndex == 1 ? !item.isEmpty : false
                
                self.btnDelete.title = nil
                self.btnDelete.image = UIImage(named: "icnDelete")
                
                self.tableView.setEditing(false, animated: true)
                self.deleteButton.isHidden = true
                
                self.bool = true
                
            }).drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        

        
        output.onItemSelect.bind {[unowned self] (declareList) in
            guard let declareList = declareList else { return }
            self.showPaymentSelect(declareList)
        }.disposed(by: disposeBag)

        output.commonDispose.disposed(by: disposeBag)
        
        tableViewEditing.bind(onNext: { value in
            self.tableView.setEditing(value, animated: true)
            self.tableView.isEditing = value
            self.deleteButton.isHidden = !value
        }).disposed(by: disposeBag)
    }
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, _, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableViewEditing.accept(bool)
        btnDelete.title = bool ? "ยกเลิก" : ""
        btnDelete.image = bool ? nil : UIImage(named: "icnDelete")
        bool = !bool
    }
    
    func segmentedControl(_ control: SWSegmentedControl, didSelectItemAtIndex index: Int) {
        segmentIndex.accept(index)
        guard control.selectedSegmentIndex == 0 else { return }
        btnDelete.image = UIImage(named: "icnDelete")
        btnDelete.title = ""
        bool = true
    }
}
extension TabDeclarationViewController {
    func showPaymentSelect(_ declareList: DeclareList){
        guard let vc = self.loadStory(identifier: "PaymentNav") as? PaymentNav else { return }
        
        vc.prepareData(declareId: declareList.declareID,
                       payment_method: declareList.paymentMethod,
                       email: declareList.email,
                       fromTab: true,
                       dismissCallback: { [unowned self]  in
                                       
                           //after declare success when close(x) navigation
                        
                            if #available(iOS 13.0, *) {
                               self.refreshData()
                            }
                         
                       })
        
        self.present(vc, animated: true, completion: nil)
    }
}


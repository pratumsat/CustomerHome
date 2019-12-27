//
//  HomePreDeclareViewController.swift
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
import RealmSwift

class HomePreDeclareViewController: C2HViewcontroller {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBAction func prepareForUnwindToHomePreDeclare(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var noItemLabel: UILabel!
    var showTaxButton: PublishSubject<IndexPath> = PublishSubject()
    
    

    
    override func viewDidLoad() {
        appTitleLabelAndNavigationDelegate(view: self)
        bind()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(true, animated: true)
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = HomePreDeclareViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try?self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        let onDelete = deleteButton.rx.tap.asDriver().filter({ [unowned self] in
            if self.tableView.indexPathsForSelectedRows == nil {
                self.alert(message: "ต้องเลือกอย่างน้อย 1 ชิ้น เพื่อทำการลบรายการ")
            }
            return self.tableView.indexPathsForSelectedRows != nil
        })
            .map({ [unowned self] _ -> [KTableCellModel]? in
                self.tableView.indexPathsForSelectedRows?.map({ [unowned self] indexpath -> KTableCellModel in
                    try! self.tableView.rx.model(at: indexpath) as KTableCellModel
                })
            })
        
        
        let input = HomePreDeclareViewModel.Input(onLoadView: onload,
                                                  onItem: onItem,
                                                  onDelete: onDelete,
                                                  onShowTax: showTaxButton.asDriver(onErrorJustReturn: IndexPath()))
        
        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] item in
                self.trashButton.isEnabled = !item.isEmpty
                self.noItemLabel.isHidden = !item.isEmpty
                
                self.trashButton.setTitle(nil, for: .normal)
                self.trashButton.setImage(UIImage(named: "icnDelete"), for: .normal)
                
                self.tableView.setEditing(false, animated: true)
                self.deleteButton.isHidden = true
                self.startButton.isHidden = false
                
                self.setMarginFooter()
            })
            .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
        
        
        trashButton.rx.tap.do(onNext: { [unowned self] _ in
            self.tableView.isEditing = !self.tableView.isEditing
            self.deleteButton.isHidden = !self.tableView.isEditing
            self.startButton.isHidden = self.tableView.isEditing
            if self.tableView.isEditing {
                self.trashButton.setImage(nil, for: .normal)
                self.trashButton.setTitle("ยกเลิก", for: .normal)
            } else {
                self.trashButton.setTitle(nil, for: .normal)
                self.trashButton.setImage(UIImage(named: "icnDelete"), for: .normal)
            }
        }).subscribe().disposed(by: disposeBag)
        
        
        viewModel.showTaxDetail.do(onNext: {[unowned self] (model) in
            self.showTax(model)
        }).subscribe().disposed(by: disposeBag)
    }

    func showTax(_ model:CalTaxResp?){

        self.performSegue(withIdentifier: "showHomeSumTax", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showHomeSumTax" else { return }
        guard let vc = segue.destination as? HomeSumTaxViewController else { return }
        vc.modelCalTaxResp.accept(sender as? CalTaxResp ?? nil)

    }
    
    
    func setMarginFooter() {
         self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            cell.button1?.rx.tap.map( {_ in return indexPath} ).bind(to: self.showTaxButton).disposed(by: cell.disposeBag!)
            
            return cell
        })
        datasource.canEditRowAtIndexPath = { _, _ in
            true
        }
        
        return datasource
    }()
   
}

extension HomePreDeclareViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.leftBarButtonItem = setThemeBackButton()
    }
}

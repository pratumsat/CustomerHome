//
//  ListItemViewController.swift
//  Customs2Home
//
//  Created by warodom on 5/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class ListItemViewController: C2HViewcontroller {
    var disposeBag: DisposeBag?
    @IBOutlet var tableView: UITableView!

    @IBOutlet var bottomView: DrawableView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet weak var btnCalTax: KButton!
    @IBOutlet var alertView: UIView!
    @IBOutlet var textCurrency: UILabel!
    @IBOutlet var imageCurrency: UIImageView!
    @IBOutlet var labelTaxDisplay: UILabel!
    @IBOutlet weak var updateCurrencyView: UIView!
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    var tableViewEditing = BehaviorRelay<Bool>(value: false)
    var preList = BehaviorRelay<PreDeclareList?>(value: nil)
    
    
    override func viewDidLoad() {
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      deleteButton.action = editButtonItem.action
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableViewEditing.accept(!tableViewEditing.value)
        bottomView.isHidden = tableViewEditing.value
        if tableViewEditing.value {
            deleteButton.image = nil
            deleteButton.title = "ยกเลิก"
            editButton.image = nil
        } else {
            deleteButton.image = UIImage(named: "icnDelete")
            editButton.image = UIImage(named: "24Px")
        }
    }

    func startedView(){
        
    }
    func bind() {
        
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ListItemViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())
        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)

        tableViewEditing.bind(onNext: { value in
            self.tableView.setEditing(value, animated: true)
            self.btnDelete.isHidden = !value
           
            
        }).disposed(by: disposeBag)
        
        let onDelete = btnDelete.rx.tap.asDriver().filter({ [unowned self] in
            if self.tableView.indexPathsForSelectedRows == nil {
                self.alert(message: "ต้องเลือกอย่างน้อย 1 ชิ้น เพื่อทำการลบรายการ")
            }
            return self.tableView.indexPathsForSelectedRows != nil
        })
            .map({ [unowned self] _ -> [KTableCellModel]? in
                self.tableView.indexPathsForSelectedRows!.map({ [unowned self] indexpath -> KTableCellModel in
                    try! self.tableView.rx.model(at: indexpath) as KTableCellModel
                })
            })
        let input = ListItemViewModel.Input(onLoadView: onload,
                                            onItem: onItem,
                                            onDelete: onDelete
        )

        let output = viewModel.transform(input: input)
        output.items?.do(onNext: { [unowned self] item in
            self.updateHeader()
            self.bottomView.isHidden = item.isEmpty
            self.noItemLabel.isHidden = !item.isEmpty
            
            self.btnAdd.isHidden = !item.isEmpty
            self.navigationItem.rightBarButtonItems?[1].isEnabled = !item.isEmpty
            self.navigationItem.rightBarButtonItems?[0].isEnabled = !item.isEmpty
            
            
            self.tableView.setEditing(false, animated: true)
            self.btnDelete.isHidden = true
            self.deleteButton.image = UIImage(named: "icnDelete")
            self.editButton.image = UIImage(named: "24Px")
            
            if !item.isEmpty {
                self.tableViewEditing.accept(false)
            }
        })
            .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
        Driver.merge(tableView.rx.itemSelected.asDriver(), tableView.rx.itemDeselected.asDriver())
            .do(onNext: { [unowned self] _ in
                self.checkSelect()
            })
            .drive().disposed(by: disposeBag)

        CurrencyViewModel.instance().selectExchange.map({ data -> String in
            "อัตราแลกเปลี่ยน \(data?.currencyCode ?? "") \(data?.rateFactor ?? 1) = THB \(data?.exchangeRate ?? 0)"
        }).bind(to: textCurrency.rx.text).disposed(by: disposeBag)
        CurrencyViewModel.instance().selectExchange.map({ data -> UIImage? in
            UIImage(named: toString(data?.currencyImage))
        }).bind(to: imageCurrency.rx.image).disposed(by: disposeBag)
        CurrencyViewModel.instance().selectExchange.map({ data -> Bool in
            let bool = data?.flagCurrencyCurrent == "Y"
            return bool
        }).bind(to: self.updateCurrencyView.rx.isHidden).disposed(by: disposeBag)
        
        
        viewModel.taxDis.map({ double -> Bool in
            return double < 40000
        }).bind(onNext: { bool in
            self.btnCalTax.isEnabled = bool
            self.alertView.isHidden = bool
            self.labelTaxDisplay.textColor = bool ? .appThemeColor : .redThemeColor
            //self.btnAdd.isHidden = !bool
        }).disposed(by: disposeBag)
        
        viewModel.taxDis.map({ double -> NSAttributedString in
            let mutiAtt = NSMutableAttributedString(attributedString:  double.delimiter.toAttributedString(currency: "THB"))
            mutiAtt.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 3))
            return mutiAtt
        }).bind(to: labelTaxDisplay.rx.attributedText).disposed(by: disposeBag)
        
        

        
        
    }

    lazy var dataSource: RxTableViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxTableViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, tableView, _, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
        })
        datasource.canEditRowAtIndexPath = { _, _ in
            true
        }
        return datasource
    }()

    @IBAction func onDelete(_ sender: Any) {
    }

    func checkSelect() {
        guard let array = tableView.indexPathsForSelectedRows else {
            btnDelete.isEnabled = false
            return
        }
        btnDelete.isEnabled = array.count > 0
    }

    func updateHeader() {
        guard let header = self.tableView.tableHeaderView else { return }
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        header.height = height
    }

    func onAddItem() {
        performSegue(withIdentifier: "openadditem", sender: self)
    }

    @IBAction func onTapAddItem(_ sender: Any) {
        ListItemViewModel.instance().calcostifUpdate.accept(nil)
        onAddItem()
    }

    @IBAction func onTapEdit(_ sender: Any) {
        onAddItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showSUmTax" else { return }
        guard let sumViewontroller = segue.destination as? SumTaxViewController else { return }
        
        sumViewontroller.onloadView.accept(ListItemViewModel.instance().modelCalTax)
    }
}

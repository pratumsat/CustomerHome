//
//  HomeSumTaxViewController.swift
//  Customs2Home
//
//  Created by thanawat on 11/29/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import RealmSwift
import RxAppState
import RxCocoa
import RxDataSources
import RxRealm
import RxSwift
import UIKit

class HomeSumTaxViewController: C2HViewcontroller {
    var disposeBag: DisposeBag?
    @IBOutlet var tableView: UITableView!
    @IBAction func prepareForUnwindToSumtax(segue: UIStoryboardSegue) {}
    @IBOutlet var labelTaxDisplay: UILabel!
    @IBOutlet var imageCurrency: UIImageView!
    @IBOutlet var textCurrency: UILabel!
    @IBOutlet var updateCurrencyView: UIView!

    @IBOutlet weak var btnDeclare: UIButton!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var btnUpdateTax: UIButton!
    @IBOutlet weak var warningView: UIView!
    
    var saveModel: PublishRelay<[PreDeclareList]?> = PublishRelay()
    var updateTax: PublishRelay<CalTaxReq?> = PublishRelay()
    
    var modelCalTaxResp:BehaviorRelay<CalTaxResp?> = BehaviorRelay<CalTaxResp?>(value: nil)
    var onloadView:BehaviorRelay<CalTaxReq?> = BehaviorRelay<CalTaxReq?>(value: nil)
    
    var isLoginRelay:BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: TokenModel.instance().isLogin())
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: NSNotification.Name(rawValue: "checkLogin"), object: nil)
        bind()
        
    }
    
    @objc func checkLogin(notification:Notification){
        isLoginRelay.accept(TokenModel.instance().isLogin())
    }
    
    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = HomeSumTaxViewModel.instance()
        viewModel.viewControl = self
        
        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        
        
        isLoginRelay.bind(onNext: {[unowned self] (isLogin) in
            self.updateDeclareButton(isLogin)
        }).disposed(by: disposeBag)
        
        
        let input = HomeSumTaxViewModel.Input(onLoadView: onloadView.asDriver(),
                                          onItem: onItem,
                                          declareButton: btnDeclare.rx.tap.asObservable(),
                                          btnUpdateTax: btnUpdateTax.rx.tap.asObservable(),
                                          onItemCalTaxResp: modelCalTaxResp )
        
        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] _ in
                self.updateHeader()
            })
            .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        output.showAlertUpdate.bind {[unowned self] (update) in
            self.showAlertUpdate()
        }.disposed(by: disposeBag)
        
        
        output.declareAddEditReq.bind {[unowned self] (declareAddEditReq) in
                self.showOrderDetail(declareAddEditReq: declareAddEditReq)
            }.disposed(by: disposeBag)
        
        output.commonDispose.disposed(by: disposeBag)
        
        if modelCalTaxResp.value != nil {
            modelCalTaxResp.filter({ return $0 != nil }).bind { model in
                self.imageCurrency.image = UIImage(named: model!.currencyImage )
                self.updateCurrencyView.isHidden = true
                self.updateHeader()
                }.disposed(by: disposeBag)
            
            viewModel.flagUpdate.map({ value -> Bool in
                return value == "Y"
            }).bind(to: self.btnUpdateTax.rx.isHidden).disposed(by: disposeBag)
            
            //viewModel.hiddenSaveButton.bind(to: self.btnSaveDraft.rx.isHidden).disposed(by: disposeBag)
            viewModel.textCurrency.bind(to: self.textCurrency.rx.text).disposed(by: disposeBag)
            viewModel.textTotalTaxDisplay.bind(onNext: { [unowned self] str in
                self.labelTaxDisplay.attributedText = str.delimiter.toAttributedString(currency: "THB")
                self.warningView.isHidden = ((toInt(str)) > 0)
            }).disposed(by: disposeBag)
            
        }
        
    }
    
    func showOrderDetail(declareAddEditReq:DeclareAddEditReq?){
        if let orderDetailVc = UIViewController.loadStory(storyboardName: "Declaration", identifier: "OrderDetailViewController") as?  OrderDetailViewController {
            orderDetailVc.declareAddEditReq = declareAddEditReq
            
            self.navigationController?.pushViewController(orderDetailVc, animated: true)
            
        }
    }
    
    func showAlertUpdate(){
        if let alert = self.loadStory(identifier: "alertUpdate") {
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateDeclareButton(_ isLogin:Bool){
        let backgroundColor:UIColor = isLogin ? .white : .blueGrayThemeColor
        let titleColor:UIColor = isLogin ? .redThemeColor : .paleTwoThemeColor
        btnDeclare.backgroundColor = backgroundColor
        btnDeclare.setTitleColor(titleColor, for: .normal)
    }
    
    func updateHeader() {
        guard let header = self.tableView.tableHeaderView else { return }
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        header.height = height
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { (_, tableView, _, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
}


extension HomeSumTaxViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoginRelay.accept(TokenModel.instance().isLogin())
        
    }
}

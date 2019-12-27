//
//  SumTaxViewController.swift
//  Customs2Home
//
//  Created by warodom on 25/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RealmSwift
import RxAppState
import RxCocoa
import RxDataSources
import RxRealm
import RxSwift
import UIKit

class SumTaxViewController: C2HViewcontroller {
    var disposeBag: DisposeBag?
    @IBOutlet var tableView: UITableView!
    @IBAction func prepareForUnwindToSumtax(segue: UIStoryboardSegue) {}
    @IBOutlet var labelTaxDisplay: UILabel!
    @IBOutlet var imageCurrency: UIImageView!
    @IBOutlet var textCurrency: UILabel!
    @IBOutlet var updateCurrencyView: UIView!
    @IBOutlet weak var btnSaveDraft: UIButton!
    @IBOutlet weak var btnDeclare: UIButton!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var btnUpdateTax: UIButton!
    @IBOutlet weak var warningView: UIView!
    
    var saveModel: PublishRelay<[PreDeclareList]?> = PublishRelay()
    var updateTax: PublishRelay<CalTaxReq?> = PublishRelay()
    
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
        let viewModel = SumTaxViewModel.instance()
        viewModel.viewControl = self
        

        
        //let onload = Driver<CalTaxReq?>.just(nil)

        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.tableView.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        let input = SumTaxViewModel.Input(onLoadView: onloadView.asDriver(),
                                          onItem: onItem,
                                          saveButton: btnSaveDraft.rx.tap.asObservable(),
                                          declareButton: btnDeclare.rx.tap.asObservable(),
                                          btnUpdateTax: btnUpdateTax.rx.tap.asObservable())

        let output = viewModel.transform(input: input)
        output.items?
            .do(onNext: { [unowned self] _ in
                self.updateHeader()
            })
            .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)


        output.showAlertUpdate.bind {[unowned self] (update) in
            self.showAlertUpdate()
            }.disposed(by: disposeBag)
        
        
        output.declareAddEditReq.bind {[unowned self] (declareAddEditReq) in
            self.showOrderDetail(declareAddEditReq: declareAddEditReq)
        }.disposed(by: disposeBag)
        
        
        viewModel.taxDis.bind(onNext: { [unowned self] str in
            self.labelTaxDisplay.attributedText = str.delimiter.toAttributedString(currency: "THB")
            self.warningView.isHidden = ((toInt(str)) > 0)
        }).disposed(by: disposeBag)
        
        //            viewModel.taxDis.map({ (int) -> NSAttributedString in
        //                int.delimiter.toAttributedString(currency: "THB")
        //            }).bind(to: labelTaxDisplay.rx.attributedText).disposed(by: disposeBag)
        //            viewModel.taxDis.map({ data in
        //                //guard data > 0 else { return "กลับหน้าแรก" }
        //                return "บันทึกรายการ"
        //            }).bind(to: self.btnSaveDraft.rx.title(for: .normal)).disposed(by: disposeBag)
        
        CurrencyViewModel.instance().selectExchange.map({ data -> String in
            "อัตราแลกเปลี่ยน \(data?.currencyCode ?? "") \(data?.rateFactor ?? 1) = THB \(data?.exchangeRate ?? 0)"
        }).bind(to: textCurrency.rx.text).disposed(by: disposeBag)
        CurrencyViewModel.instance().selectExchange.map({ data -> UIImage? in
            UIImage(named: toString(data?.currencyImage))
        }).bind(to: imageCurrency.rx.image).disposed(by: disposeBag)
        CurrencyViewModel.instance().selectExchange.map({ data -> Bool in
            let bool = data?.flagCurrencyCurrent == "Y"
            return bool
        }).bind(to: updateCurrencyView.rx.isHidden).disposed(by: disposeBag)
        
        isLoginRelay.bind(onNext: {[unowned self] (isLogin) in
            self.updateDeclareButton(isLogin)
        }).disposed(by: disposeBag)
 
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
    
    func goToHomePreDeClare(){
        self.performSegue(withIdentifier: "showAlertSave", sender: nil)
//        self.navigationController?.viewControllers.forEach({ (viewController) in
//            guard let homeVc = viewController as? HomePreDeclareViewController else { return }
//            self.navigationController?.popToViewController(homeVc, animated: true)
//        })
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

extension SumTaxViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoginRelay.accept(TokenModel.instance().isLogin())
        
    }
}

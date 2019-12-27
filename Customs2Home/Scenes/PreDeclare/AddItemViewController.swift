//
//  AddItemViewController.swift
//  Customs2Home
//
//  Created by warodom on 24/9/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import RxAppState
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class AddItemViewController: UIViewController {
    var disposeBag: DisposeBag?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var warrantyTextField: UITextField!
    @IBOutlet var freightTextField: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var warrantySwitch: UISwitch!
    @IBOutlet weak var textCurrency: UILabel!
    @IBOutlet weak var textCurrency2: UILabel!
    @IBOutlet weak var warrantyView: UIView!
    
    
    var dataCalCostReq: CalCostReq?
    var showCat: PublishSubject<IndexPath> = PublishSubject()
    var onChangeItemInfo:PublishSubject<ItemView> =  PublishSubject()
    var onDeleteItem:PublishSubject<ItemView> =  PublishSubject()
    var validateButton:PublishSubject<Bool> = PublishSubject()
    //var onTextChange:PublishSubject<String> =  PublishSubject()
    
    
    override func viewDidLoad() {
        bind()
        bindTextChange(freightTextField)
        bindTextChange(warrantyTextField)
    }
    
    
    func bind() {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = AddItemViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just(())

//        let onItem = tableView.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
//            try?self.tableView.rx.model(at: path)
//        }).asDriver(onErrorJustReturn: nil)
        let input = AddItemViewModel.Input(onLoadView: onload,
                                           onItem: nil, onSelectCat: showCat.asDriver(onErrorJustReturn: IndexPath()))

        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
        if let data = ListItemViewModel.instance().calcostifUpdate.value {
            printRed("Has Data Item \(data)")
            data.preDeclareList?.forEach({data in
                addItem(animation: false, predeclare: data)
            })
            if data.preDeclareList?.isEmpty ?? false {
                addItem(animation: false)
            }else{
                freightTextField.text = data.freight == 0 ? nil : data.freight?.delimiter
                warrantyView.isHidden = !((data.insurance ?? 0) > 0)
                warrantySwitch.isOn = (data.insurance ?? 0) > 0
                warrantyTextField.text = data.insurance == 0 ? nil : data.insurance?.delimiter
                
            }
            
        } else {
            addItem(animation: false)
           
        }
        if let currency = CurrencyViewModel.instance().selectExchange.value {
            textCurrency.text = currency.currencyCode
            textCurrency2.text = currency.currencyCode
        }
        
        onChangeItemInfo.bind(onNext: { [unowned self] (itemView) in
            guard itemView.tariffIdentify != nil else { return }
            let sameItemArray = self.stackView.arrangedSubviews
                .filter({ (view) -> Bool in
                guard let refItemView = view as? ItemView else {return false}
                return itemView.isEqual(refItemView)
            })
            .map({ $0 as! ItemView })
            let max = toInt( sameItemArray.first?.tariffButton.tariff?.qtyLimit )
            
            let sum = sameItemArray.reduce(0, { (result, itemView) -> Int in
                return result + toInt( itemView.qtyText.text?.splitComma )
            })
            let shouldShowQtyMsg = (max != 0) && ( max < sum )
            sameItemArray.forEach({ (itemView) in
                itemView.isShowMsgWarning = shouldShowQtyMsg
                itemView.isShowViewMsgWarning = false
            })
            itemView.isShowViewMsgWarning = shouldShowQtyMsg
            
        }).disposed(by: disposeBag)
        
        onDeleteItem.bind(onNext: {[unowned self] itemView in
            
            let itemArray = self.stackView.arrangedSubviews.filter({ ($0 as? ItemView) != nil })
            if let index = itemArray.firstIndex(of: itemView) {
                if index == 0  && itemArray.count == 1{
                    itemView.tariffButton.tariffRelay.accept(nil)
                    itemView.tariffButton.setTitle(nil, for: .normal)
                    itemView.priceText.text = nil
                    itemView.qtyText.text = nil
                    itemView.isShowMsgWarning = false
                    itemView.isShowViewMsgWarning = false
                }else{
                    itemView.removeFromSuperview()
                }
            }
            
            self.stackView.arrangedSubviews.filter({ ($0 as? ItemView) != nil }).enumerated()
                .forEach({ (index,view) in
                    guard let refItemView = view as? ItemView else {return }
                    
                    let titleLabel = view.view(withId: "titleLabel") as! UILabel
                    titleLabel.text = "productOrder".localizable() + toString(index + 1)
                    if index == 0 {
                        refItemView.tariffButton.tariffRelay
                            .map({ $0 == nil })
                            .bind(to: refItemView.deleteButton.rx.isHidden)
                            .disposed(by: self.disposeBag!)
                    }
            })
            
            guard itemView.tariffIdentify != nil else { return }
            let sameItemArray = self.stackView.arrangedSubviews
                .filter({ (view) -> Bool in
                    guard let refItemView = view as? ItemView else {return false}
                    return itemView.isEqual(refItemView)
                })
                .map({ $0 as! ItemView })
            let max = toInt( sameItemArray.first?.tariffButton.tariff?.qtyLimit )
            
            let sum = sameItemArray.reduce(0, { (result, itemView) -> Int in
                return result + toInt( itemView.qtyText.text?.splitComma )
            })
            let shouldShowQtyMsg = (max != 0) && ( max < sum )
            sameItemArray.forEach({ (itemView) in
                itemView.isShowMsgWarning = shouldShowQtyMsg
            })
            sameItemArray.last?.isShowViewMsgWarning = shouldShowQtyMsg
            
            
        }).disposed(by: disposeBag)
        
        
        validateButton
            .map(self.validateSaveButton())
            .bind(to: self.btnSave.rx.isEnabled)
            .disposed(by: disposeBag)
        
      
        let warrantyTextFieldValue = warrantyTextField.rx.text.orEmpty
        let warrantySwitchValue = warrantySwitch.rx.value
        let freightTextFieldValue = freightTextField.rx.text.orEmpty
        
        Observable.combineLatest(warrantyTextFieldValue, freightTextFieldValue, warrantySwitchValue,
                                 resultSelector: { [unowned self] (text, text2 ,switchOn ) in
                                    guard switchOn else { return self.validFreight() }
                                    return toDouble(text.splitComma) > 0 && (text2.isEmpty ? true : toDouble(text2.splitComma) > 0)
                                })
                .bind(to: self.validateButton)
                .disposed(by: self.disposeBag!)
        
        
    }
    
    func validWarrantyAndFreight() -> Bool{
        let freightText = self.freightTextField.text!
        let warrantyText = self.warrantyTextField.text!
        return  toDouble(warrantyText.splitComma) > 0 && (freightText.isEmpty ? true : toDouble(freightText.splitComma) > 0)
    }
    func validFreight() -> Bool{
        let freightText = self.freightTextField.text!
        return (freightText.isEmpty ? true : toDouble(freightText.splitComma) > 0)
    }
    
    func validateSaveButton() -> ( (Bool)-> Bool) {
        return { [unowned self] validateWarranty in
            var error = 0
            self.stackView.arrangedSubviews.forEach({ (view) in
                guard let refItemView = view as? ItemView else {return}
                let enable =  !refItemView.isShowMsgWarning
                    && refItemView.preDeclareList != nil
                    && toDouble(refItemView.qtyText.text!.splitComma) > 0
                    && toDouble(refItemView.priceText.text!.splitComma) > 0
                    && validateWarranty
                
                if !enable {
                    error += 1
                }
                self.btnSave.isEnabled = error == 0 ? true : false
            })
            return error == 0 ? true : false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
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

    @IBAction func onWarranty(_ sender: UISwitch) {
        warrantyView.isHidden = !sender.isOn
        if !sender.isOn {
            warrantyTextField.text = ""
        }
    }

    @IBAction func onAddItem(_ sender: UIButton) {
        addItem(animation: true)
    }

    @IBAction func onSubmitItem(_ sender: UIButton) {
        if let result = try? self.stackView.arrangedSubviews.filter({ $0 is ItemView }).map { view throws -> PreDeclareList in
            let view = view as! ItemView
            guard let preDeclareList = view.preDeclareList else { throw KError.commonError(message: "Some view no preDecalarList") }
            return preDeclareList
        } {
            guard let exchange = CurrencyViewModel.instance().selectExchange.value else { return }
//            printBlue("DoneX", result)
            let x = CalCostReq(exchangeRateList: exchange, freight: toDouble(freightTextField.text?.splitComma) , insurance: toDouble(warrantyTextField.text?.splitComma), preDeclareList: result)
            ListItemViewModel.instance().calcostif.accept(x)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func onSelectCategory(button: UIButton) {
        performSegue(withIdentifier: "showCatagoryViewController", sender: button)
    }

    func addItem(animation: Bool, predeclare: PreDeclareList? = nil) {
        let action = { [unowned self] in
            if let view = UIView.loadNib(name: "AddViewCell")?.first as? ItemView {
                view.scrollViewButton.becomeFirstResponder()
                view.isHidden = true; view.alpha = 0; view.qtyView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                //view.deleteButton.isHidden = !animation
                view.tariffButton.setTitle("กรุณาเลือกประเภทสินค้า", for: .normal); view.tariffButton.setTitleColor(UIColor.borderThemeColor, for: .normal)
                
                if let pre = predeclare {
                    view.tariffButton.tariffRelay.accept( pre.tarriff )
                    view.priceText.text =  pre.unitPrice.delimiter
                    view.qtyText.text = toString(pre.quantity)
                }
                
                

                let categoryButton = view.view(withId: "categoryButton") as! KButton
                
                categoryButton.rx.controlEvent(.touchDragInside).bind(onNext: {
                    view.scrollViewButton.resignFirstResponder()
                }).disposed(by: self.disposeBag!)

                categoryButton.rx.controlEvent(.touchUpInside).bind(onNext: { [unowned self] in
                    self.onSelectCategory(button: categoryButton)
                }).disposed(by: self.disposeBag!)
                
                
                if let index = self.stackView.arrangedSubviews.firstIndex(of: self.addItemView) {
                    self.stackView.insertArrangedSubview(view, at: index)
                    view.isHidden = false; view.alpha = 1

                    let titleLabel = view.view(withId: "titleLabel") as! UILabel
                    titleLabel.text = "productOrder".localizable()  + toString(index + 1)

//                    self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height )
                    if index == 0 {
                        view.tariffButton.tariffRelay
                            .map({ $0 == nil })
                            .bind(to: view.deleteButton.rx.isHidden)
                            .disposed(by: self.disposeBag!)
                    }
                    
                }

                let cerrencyText = view.view(withId: "cerrencytext") as! UILabel
                CurrencyViewModel.instance().selectExchange.map({ data in
                    data?.currencyCode
                }).bind(to: cerrencyText.rx.text).disposed(by: self.disposeBag!)

                Observable<ItemView>.merge( [ view.qtyText.rx.text.orEmpty.map({ _ in view }),
                                              view.priceText.rx.text.orEmpty.map({_ in view}),
                                              view.tariffButton.tariffRelay.map({_ in view})] )
                    .bind(to: self.onChangeItemInfo).disposed(by: self.disposeBag!)
                
                
                //combind
                Observable.combineLatest(view.qtyText.rx.text.orEmpty,
                                         view.priceText.rx.text.orEmpty,
                                         view.tariffButton.tariffRelay.map({ $0 != nil }),
                                         self.warrantySwitch.rx.value,
                                         resultSelector: { [unowned self] (text , text2, tariff,switchOn ) in
                                            guard switchOn else { return self.validFreight() }
                                            return !text.isEmpty && !text2.isEmpty && tariff && self.validWarrantyAndFreight()
                                        })
                    .bind(to: self.validateButton)
                    .disposed(by: self.disposeBag!)
                
                view.deleteButton.rx.tap.map({_ in view })
                    .bind(to: self.onDeleteItem).disposed(by: self.disposeBag!)
                
                view.deleteButton.rx.tap.asObservable()
                    .map({ [unowned self] _ -> Bool in
                        guard self.warrantySwitch.isOn else { return self.validFreight() }
                        return self.validWarrantyAndFreight()
                    })
                    .bind(to: self.validateButton)
                    .disposed(by: self.disposeBag!)
                
                
                self.bindTextChange(view.qtyText)
                self.bindTextChange(view.priceText)
                
            }
        }

        if animation {
            UIView.animate(withDuration: 0.25, animations: action)
        } else {
            action()
        }
    }
    
    func bindTextChange(_ textField:UITextField){
        textField.rx.text.orEmpty
            .scan("", accumulator: self.validateNumber )
            .map({ newText -> String in
                if let dotIndex = newText.firstIndex(of: ".") {
                    let numDigit = newText.distance(from: newText.startIndex, to: dotIndex)
                    let index1 = newText.index(newText.startIndex, offsetBy: numDigit)
                    let numberDigits = String(newText[..<index1])
                    let decimalDigits = String(newText[index1...])
                    
                    return "\(numberDigits.thousandFormatted)\(decimalDigits)"
                }else{
                    return newText.thousandFormatted
                }
                
            })
            .bind(onNext: textField.setPreservingCursor() )
            .disposed(by: self.disposeBag!)
    }
    
    func validateNumber( prevoius:String, newText:String) -> String{
        guard let number = Double(newText.splitComma) else { return "" }
        guard number < 100000000 else { return prevoius }
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        guard numberOfDecimalDigits <= 2 else { return prevoius }
        return newText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let catagoryViewController = segue.destination as? CatagoryViewController {
            let sender = sender as! TariffButton
            //            sender.rx.tariff.onn
            catagoryViewController.rx.didCompleteSelect.bind(to: sender.tariffRelay ).disposed(by: self.disposeBag!)
            //                .subscribe(onNext: { tariffList in
            //                    sender.tariff = tariffList
            //
            //                    sender.sizeThatFits(CGSize(width: sender.intrinsicContentSize.width + 10, height: sender.intrinsicContentSize.height + 10))
            //                })
            //                .disposed(by: disposeBag!)
        }
    }
}

extension Reactive where Base: AddItemViewController {
    internal var didSubmitData: Observable<[PreDeclareList]>? {
        return nil
    }
}

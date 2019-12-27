//
//  DeclarationViewController.swift
//  Customs2Home
//
//  Created by warodom on 18/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class DeclarationViewController: C2HViewcontroller {
    

    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totolTaxLabel: UILabel!
    @IBOutlet weak var trackingNoLabel: UILabel!
    
    @IBOutlet weak var addDeclareButton: UIButton!
    
    var declareAddEditReq: DeclareAddEditReq?
    var url : [(String,UIImage)]?
    
    var declareId:String?
    
    override func viewDidLoad() {
        bind()
        initStepView4(mainView: stepView, label1: .appThemeColor, label2: .appThemeColor, label3: .appThemeColor, label4: .appThemeColor, viewLeft: .appThemeColor, viewCenter: .appThemeColor, viewRight: .appThemeColor)
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = DeclarationViewModel.instance()
        viewModel.viewControl = self
       

        let onItem = imageCollection.rx.itemSelected.map({ [unowned self] path -> KTableCellModel? in
            try? self.imageCollection.rx.model(at: path)
        }).asDriver(onErrorJustReturn: nil)
        
        
         let onload = Driver.just((url))
        
        let input = DeclarationViewModel.Input( onLoadView: onload,
                                                onCalTaxResp: Observable.just(()),
                                                onItem: onItem,
                                                declareAddEditReq: Observable.just(declareAddEditReq),
                                                addDeclare: addDeclareButton.rx.tap.asObservable() )

        let output = viewModel.transform(input: input)
        output.items?.drive( self.imageCollection.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        
        
        output.calTaxResp.bind(onNext: { (respond) in
            self.nameLabel.text = respond.0
            self.totolTaxLabel.attributedText = respond.1
        }).disposed(by: disposeBag)
        
        output.declareSuccess.bind(onNext: {[unowned self] responds in
            print("Declared Success declareId =  \(responds.first?.id)")
            self.declareId  = responds.first?.id
            self.showUploadProgress(responds: responds)

        }).disposed(by: disposeBag)
        
        if let respond = declareAddEditReq {
            trackingNoLabel.text = respond.trackingID
        }
        
        output.commonDispose.disposed(by: disposeBag)
    }
    
    func showUploadProgress(responds:[(id:String, tracking:String, type:String,  image:Data)]){
        self.performSegue(withIdentifier: "showUploadProgress", sender: responds)
    }
    
    func showPaymentNavMethod(){
        self.performSegue(withIdentifier: "showPaymentNavMethod", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showUploadProgress":
            let vc = segue.destination as! UploadProgressViewController
            vc.responds = (sender as? [(id:String, tracking:String, type:String,  image:Data)]) ?? nil
            vc.uploadFileCallback = { (fileUploads) in
                
                vc.dismiss(animated: true, completion: {
                    self.showPaymentNavMethod()
                })
            }
            break
        case "showPaymentNavMethod":
            let vc = segue.destination as! PaymentNav
            vc.prepareData(declareId: self.declareId,
                           email: self.declareAddEditReq?.email,
                           dismissCallback: { [unowned self] in
                //after declare success when close(x) navigation
                self.navigationController?.popToRootViewController(animated: true)
            })

            break
            
        default:
            break
        }
    }
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<KTableCellSection> = {
        let datasource = RxCollectionViewSectionedReloadDataSource<KTableCellSection>(configureCell: { (_, collectionview, indexPath, cellModel) -> UICollectionViewCell in
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellModel.cellIden, for: indexPath) as? KCollectionViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
        })
//        datasource.canEditRowAtIndexPath = { _, _ in
//            true
//        }
        return datasource
    }()
}

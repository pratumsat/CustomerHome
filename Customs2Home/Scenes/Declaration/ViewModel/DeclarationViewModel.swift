//
//  DeclarationViewModel.swift
//  Customs2Home
//
//  Created by warodom on 18/11/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class DeclarationViewModel: BaseViewModel<DeclarationViewModel>,ViewModelProtocol {

    typealias M = DeclarationViewModel
    typealias T = DeclarationViewController
    static var obj_instance: DeclarationViewModel?
    
//    var loadingScreen: ScreenLoadingView? {
//        return viewControl?.view.getScreenLoading()
//    }

    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        let calTaxResp = input.onCalTaxResp.flatMapLatest( getCalTaxResp )
            .map { (respond) -> (String,NSAttributedString) in
                var name = ""
                respond?.tariffList?.enumerated().forEach({ (offset,model) in
                    if offset != 0 {
                        name += ", \(model.tariffName ?? "")"
                    }else{
                        name += "\(model.tariffName ?? "")"
                    }
                })
               
                let attributedString = NSMutableAttributedString(string: "THB \(respond?.totalTaxDisplay?.delimiter ?? "0" )  ", attributes: [
                    .font: UIFont.mainFontSemiBold(ofSize: 24),
                    .foregroundColor: UIColor(red: 87.0 / 255.0, green: 166.0 / 255.0, blue: 0.0, alpha: 1.0)
                    ])
                attributedString.addAttribute(.font, value: UIFont.mainFontRegular(ofSize: 12), range: NSRange(location: 0, length: 3))
                
                return ("สินค้า: \(name)" , attributedString)
            }
        
        let declareID = input.addDeclare
            .withLatestFrom(input.declareAddEditReq)
            .flatMapLatest( getDeclareApi )
 
        let declareSuccess = Observable
            .combineLatest(declareID ,input.declareAddEditReq , input.onLoadView.asObservable(),
                           resultSelector: { (id, model, urls) -> [(id:String, tracking:String, type:String,  image:Data)] in
                                var responds:[(id: String, tracking: String, type: String, image: Data)] = []
                                urls?.forEach({ (url) in
                                    responds.append((id: toString(id),
                                                     tracking: model?.trackingID ?? "",
                                                     type: url.0,
                                                     image: url.1.jpegData(compressionQuality: 1.0)!) )
                                })
                            
                                return responds
                            })
        
        return DeclarationViewModel.Output(items: item,
                                           calTaxResp: calTaxResp,
                                           declareSuccess: declareSuccess,
                                           commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func getDeclareApi(_ declareAddEditReq: DeclareAddEditReq? = nil) -> Observable<Int?>{
        guard let loadingScreen = self.loadingScreen, let model = declareAddEditReq  else { return .just(nil) }
      
        let baseRequest = BaseRequestDeclareAddEdit(declareAddEditReq: model)
        let service = AddEditDeclareApi().callService(request: baseRequest)
        let loading = loadingScreen.observeLoading(service , shouldRetry: { (error) -> Bool in
            guard let k_error = error as? KError else {return false}
            let errorMessage = k_error.getMessage
            let code = " (\(toString( errorMessage.codeString )))"
            self.viewControl?.alert(message: toString( errorMessage.message ) + code)
            return false
        })
            .map({ respond -> Int? in
                if let calTaxId = model.calTaxId {
                    ConfigRealm().deleteByCalTaxId(calTaxId)
                    HomePreDeclareViewModel.instance()
                        .onReloadItem
                        .accept(HomePreDeclareViewModel.instance().parser(ConfigRealm().getCalTaxResp()))
                }
                
                return respond.declareResp?.declareID
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    func getCalTaxResp() -> Observable<DeclareAddEditReq?> {
        
        guard let loadingScreen = self.loadingScreen  else {return .just(nil)}
        
        
        let service = Observable.just(viewControl?.declareAddEditReq)
        let loading = loadingScreen.observeLoading(service)
            .map({ respond -> DeclareAddEditReq? in
                return respond
            })
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
        return loading
        
    }
    func fecthdata(url: ([(String,UIImage)])? ) -> Driver<[KTableCellSection]> {
        
        guard let loadingScreen = self.loadingScreen , let imageUrls = url else {return .just([])}
        
        let service = Observable.just(imageUrls)
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> [KTableCellSection] in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: [])
        return loading
        
    }
    
    func parser(_ respond:[(String,UIImage)]) -> [KTableCellSection]
    {
        var sections = [KTableCellSection]()
        var cells = [KTableCellModel]()
        
        
        respond.forEach { (data) in
            let cell = applyCellTable(byName: "imagecell", cellArray: &cells)
            cell.image.accept(data.1)
        }
        
        
        sections.append(KTableCellSection(items: cells))
        return sections
    }
    
    func getImageFromDir(_ url: URL) -> UIImage? {
    
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Not able to load image")
        }
        
        return nil
    }
    
    private func applyCellTable( byName name:String, cellArray:inout [KTableCellModel]) -> KTableCellModel
    {
        let count = cellArray.count
        let cell =  KTableCellModel(identity: count, cellIden: name)
        cellArray.append( cell )
        return cell
    }
    
}

extension DeclarationViewModel {
    struct Input {
        let onLoadView: Driver<[(String,UIImage)]?>
        let onCalTaxResp: Observable<Void>
        let onItem: Driver<KTableCellModel?>
        let declareAddEditReq : Observable<DeclareAddEditReq?>
        let addDeclare: Observable<Void>
    }
    
    struct Output {
        let items: Driver< [KTableCellSection] >?
        let calTaxResp: Observable<(String,NSAttributedString)>
        let declareSuccess: Observable<[(id:String, tracking:String, type:String,  image:Data)]>
        let commonDispose: CompositeDisposable
    }
}

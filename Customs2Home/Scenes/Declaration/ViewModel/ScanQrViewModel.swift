//
//  ScanQrViewModel.swift
//  Customs2Home
//
//  Created by warodom on 16/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire


class ScanQrViewModel: BaseViewModel<ScanQrViewModel>,ViewModelProtocol {

    typealias M = ScanQrViewModel
    typealias T = ScanQrViewController
    static var obj_instance: ScanQrViewModel?
    
    override init() {
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let commonDispose = [Disposable]()
        let item = input.onLoadView.flatMapLatest( fecthdata )
        return ScanQrViewModel.Output(items: item,
                                             commonDispose: CompositeDisposable(disposables: commonDispose) )
    }
    
    
    func fecthdata(declareId: Int?) -> Driver<UIImage?> {
        
        guard let loadingScreen = self.loadingScreen , let declareId = declareId else {return .just(nil)}
        
        let service = GetQRCodeApi().callService(request: BaseRequestQrCodeReq(declareId: declareId))
        let loading = loadingScreen.observeLoading(service)
        .map({ [unowned self] respond -> UIImage? in
            return self.parser( respond)
        })
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .asDriver(onErrorJustReturn: nil)
        return loading
        
    }
    
    func parser(_ respond:BaseRespone_QRcode) -> UIImage?
    {
        viewControl?.ref1Label.text =  respond.qrCodeResp?.ref1
        viewControl?.ref2Label.text = respond.qrCodeResp?.ref2
        viewControl?.amountLabel.text = respond.qrCodeResp?.amount
        
        guard let image = viewControl?.generateQRCode(from: toString(respond.qrCodeResp?.qrText)) else { return nil }
//        guard let image = viewControl?.generateQRCode(from: "00020101021130630016A000000677010112011509940010176893502203020191204000031000153037645802TH6304845B") else { return nil }
        return image
    }
}

extension ScanQrViewModel {
    struct Input {
        let onLoadView: Driver<Int?>
    }
    
    struct Output {
        let items: Driver<UIImage?>
        let commonDispose: CompositeDisposable
    }
}

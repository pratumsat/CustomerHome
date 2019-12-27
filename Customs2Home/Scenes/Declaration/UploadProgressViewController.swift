//
//  UploadProgressViewController.swift
//  Customs2Home
//
//  Created by thanawat on 12/4/19.
//  Copyright © 2019 Wittawas Mukdaprasert. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState
import Alamofire
import ObjectMapper

class UploadProgressViewController: UIViewController {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var responds:[(id:String, tracking:String, type:String,  image:Data)]?
    
    var itemObs:[Observable<BaseRespones_Upload>] = []
    
    var uploadFileResps:[UploadFileResp] = [] {
        didSet{
            if uploadFileResps.count == responds?.count {
                self.uploadFileCallback?(self.uploadFileResps)
            }
        }
    }
    var uploadFileError:((BaseRespones_Upload)->Void)?
    var uploadFileCallback:(([UploadFileResp])->Void)?
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = UploadProgressViewModel.instance()
        viewModel.viewControl = self
        
        guard let responds = responds else { return }
   
        
        let input = UploadProgressViewModel.Input(onLoadView: responds)
        let output = viewModel.transform(input: input)
      
        output.uploaded
            .bind {[unowned self] (uploadResp) in
                guard  uploadResp.statusCd == "0000" else  {
                    self.uploadFileError?(uploadResp)
                    return
                }
                
                
                guard let uploadFileResp = uploadResp.uploadFileResp else { return }
                self.uploadFileResps.append(uploadFileResp)
            }.disposed(by: disposeBag)
        
        
        output.process.bind(to : progressView.rx.progress)
            .disposed(by: disposeBag)
        
        output.process
            .map( { $0 * 100 })
            .map({ (value) -> String in
                return "Upload Progress \(toString(Int(value)))%" })
            .bind(to: progressLabel.rx.text)
            .disposed(by: disposeBag)
      
//        output.process
//            .map( { $0 * 100 })
//            .filter({ Int($0) == 100 })
//            .bind(onNext: { (percent) in
//                printRed( "\(percent)%")
//            })
//            .disposed(by: disposeBag)
        

        //handle error
        self.uploadFileError = {[unowned self] (responds) in
            print(responds)
            let errorMessage = convenientLangCompair(interLang: responds.statusDescEN  , altLang: responds.statusDescTH) ?? ""
            let code = responds.statusCd ?? ""
            self.progressLabel.text = "ล้มเหลว: \(errorMessage) \(code)"
            self.progressLabel.textColor = .gray
        }
        
        output.commonDispose.disposed(by: disposeBag)
        
    }
    
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

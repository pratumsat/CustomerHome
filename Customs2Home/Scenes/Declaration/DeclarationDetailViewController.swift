//
//  DeclarationDetailViewController.swift
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
import Alamofire
import ObjectMapper

class DeclarationDetailViewController: C2HViewcontroller {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnAddtem: UIButton!
    
    @IBOutlet weak var declareButton: UIButton!
    @IBOutlet weak var trackingNoTextField: UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var validateImageView: UIImageView!
    
    let keywordRelay = BehaviorRelay<String>(value: "")
    var declareAddEditReq: DeclareAddEditReq? 
    
    var imagePicker: ImagePicker!
    
    var paySlipObservable = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        
        bind()
        initStepView4(mainView: stepView, label1: .appThemeColor, label2: .appThemeColor, label3: .appThemeColor, label4: .borderThemeColor, viewLeft: .appThemeColor, viewCenter: .appThemeColor, viewRight: .borderThemeColor)
            addView(animation: false, titleName:"แนบหลักฐานการชำระเงิน")
            addView(animation: false, titleName:"ใบสั่งซื้อสินค้า (ถ้ามี)")
            addView(animation: false)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = DeclarationDetailViewModel.instance()
        viewModel.viewControl = self
        
        
        let invalidImage = UIImage(named: "icValid-error")
        let validImage = UIImage(named: "icValid")
        
        trackingNoTextField.rx.text.orEmpty
            .scan("") { (previous, newText) -> String in
                return newText.count <= 13 ? newText : previous
            }
            .bind(onNext: trackingNoTextField.setPreservingCursor(true) )
            .disposed(by: disposeBag)
        
        trackingNoTextField.rx.controlEvent([.editingDidEndOnExit])
            .map({[unowned self] _ in self.trackingNoTextField.text! })
            .bind(to: keywordRelay)
            .disposed(by: disposeBag)
        
//        let searchAction = trackingNoTextField.rx.controlEvent([.editingChanged]).asObservable()
        let searchAction = Observable.merge(trackingNoTextField.rx.controlEvent([.editingDidEndOnExit]).asObservable(),                                             trackingNoTextField.rx.controlEvent([.editingChanged]).asObservable())

        let onload = Observable.just(())
        let input = DeclarationDetailViewModel.Input( onLoadView: onload,
                                                      trackingNO: trackingNoTextField.rx.text.orEmpty.asObservable(),
                                                      paySlip: paySlipObservable.asObservable(),
                                                      searchAction: searchAction,
                                                      declareAction : declareButton.rx.tap.asObservable() )
        
        let output = viewModel.transform(input: input)
        
        
        output.errorValidate.bind {[unowned self] (messageError) in
            self.validateImageView.image = invalidImage
            self.declareButton.isEnabled = false
        }.disposed(by: disposeBag)
        
       
        output.trackingResult.map({ (valid) -> UIImage? in
            return valid ? validImage : invalidImage
        }).bind(to: validateImageView.rx.image ).disposed(by: disposeBag)
        
        
        output.nextStep.bind {[unowned self] (respond) in
            self.showDeclareStep4(data: respond)
        }.disposed(by: disposeBag)
        
        output.showButton.bind(to: declareButton.rx.isEnabled).disposed(by: disposeBag)
        output.commonDispose.disposed(by: disposeBag)
        
        btnAddtem.rx.tap
            .scan(0, accumulator: { (a, _)  in
                return a + 1
            })
            .bind(onNext: { [unowned self] (count) in
                if count <= 7 {
                    self.addView(animation: true)
                }
                
        }).disposed(by: disposeBag)
    }
    
    func addView(animation: Bool , titleName:String? = nil){
        if let view = UIView.loadNib(name: "AddItemDeclarationView")?.first as? DeclarationView {
            if let titleName = titleName {
                view.title.text = titleName
            }
            if animation{
                UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                    self.stackView.insertArrangedSubview(view, at: self.stackView.arrangedSubviews.count - 1)
                })
            } else {
                self.stackView.insertArrangedSubview(view, at: self.stackView.arrangedSubviews.count - 1)
            }
            view.btnSelectImage.rx.tap.bind(onNext: {
                self.imagePicker.present(from: view.btnSelectImage, { [unowned self] (image , imageURL) in
                    guard var image =  image  else { return }
                    
                    
                    if var size = image.getFileSize() {
                        print("filesize \(size), \(type(of: size))")
                        let maxSize = 5 * (1000 * 1000)
                        while size > maxSize {

                            image = image.resized(withPercentage: 0.8)!
                            size = image.getFileSize()!
                           
                            print("resize \(size), \(type(of: size))")
                        }
                        
                    }
                    
                    view.imageFile = image
                    view.imageURL = imageURL
                    
                    guard let indexView = self.stackView.arrangedSubviews.firstIndex(of: view) else{ return }
                    switch indexView {
                        case 2:
                            self.paySlipObservable.accept("fill")
                            view.modelUrl = ("PAYMENT_SLIP", image)
                            break;
                        case 3:
                            view.modelUrl = ("ORDER_PRODUCT", image)
                            break;
                        default:
                            view.modelUrl = ("OTHER", image)
                            break
                    }
                    
                })
             
            }).disposed(by: disposeBag!)
        }
    }
    
    func showDeclareStep4(data: DeclareAddEditReq?){
        self.performSegue(withIdentifier: "showDeclareStep4", sender: data)
    }
//    @IBAction func OnSave(_ sender: UIButton) {
        /*
//        let i = UploadDeclareApi().createUrlReqNoSecurity([:])
        let urlStr = (Router.uploadDeclareFile([:]).apiModel.base)+(Router.uploadDeclareFile([:]).apiModel.path)
        
        
        
        uploadImage(imageUrl: url.first!, url: urlStr).subscribe(onNext: { data in
            printRed(data)
        }).disposed(by: disposeBag!)
       */
//    }
    
    
 
}

extension DeclarationDetailViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, imageURL: URL?) {
//         if let view = self.stackView.arrangedSubviews.filter({ $0 is DeclarationView}).first as? DeclarationView {
//            view.imageFile = image
//            view.imageURL = imageURL
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "showDeclareStep4" else { return }
        guard let vc = segue.destination as? DeclarationViewController else { return }
        vc.declareAddEditReq = sender as? DeclareAddEditReq ?? nil
        
        var urls:[(String,UIImage)] = []
        
        self.stackView.arrangedSubviews.forEach { (view) in
            guard let view = view as? DeclarationView else { return }
            guard let  modelUrl = view.modelUrl else { return }
            urls.append(modelUrl)
        }
        vc.url = urls
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.registKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.resignKeyboardNotification()
    }
}

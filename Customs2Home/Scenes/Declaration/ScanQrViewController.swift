//
//  ScanQrViewController.swift
//  Customs2Home
//
//  Created by warodom on 6/12/2562 BE.
//  Copyright © 2562 Wittawas Mukdaprasert. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import RxAppState

class ScanQrViewController: UIViewController,UIImagePickerControllerDelegate {
    
    var disposeBag :DisposeBag?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ref1Label: PaddingLabel!
    @IBOutlet weak var ref2Label: PaddingLabel!
    @IBOutlet weak var amountLabel: PaddingLabel!
    @IBOutlet weak var viewQR: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var declareId : Int?
    
    override func viewDidLoad() {
        bind()
    }
    func bind()  {
        self.disposeBag = DisposeBag()
        let disposeBag = self.disposeBag!
        let viewModel = ScanQrViewModel.instance()
        viewModel.viewControl = self
        let onload = Driver.just((declareId))
        let input = ScanQrViewModel.Input( onLoadView: onload)


        let output = viewModel.transform(input: input)
//        output.items?.drive( self.tableView.rx.items(dataSource: dataSource) ).disposed(by: disposeBag )
        output.items.drive( self.imageView.rx.image ).disposed(by: disposeBag )
        output.commonDispose.disposed(by: disposeBag)
        
//        output.items.asObservable().subscribe(onNext: { [unowned self] image in
//            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }).disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            UIImageWriteToSavedPhotosAlbum(image! , self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        })
        
    }
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let paymentnav = self.navigationController as? PaymentNav {
                paymentnav.dismissCallback?()
            }
        })
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<KTableCellSection>(
        configureCell: { ( _, tableView, indexPath, cellModel) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIden) as? KTableViewCell else { fatalError("Set wrong cell Iden or Wrong class") }
            cell.bind(cellData: cellModel)
            return cell
    })
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.iso2022JP)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}

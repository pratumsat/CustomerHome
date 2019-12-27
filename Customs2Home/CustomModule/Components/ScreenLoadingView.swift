//
//  ScreenLoadingView.swift
//  VRT Mobile
//
//  Created by Wittawas Mukdaprasert on 19/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIView {
    
    func getScreenLoading() -> ScreenLoadingView?
    {
        for view in self.subviews {
            if let view = view as? ScreenLoadingView {
                return view
            }
        }
        if let loadView = UIView.loadNib(name: "ScreenLoadingView")?.first as? ScreenLoadingView {
            loadView.alpha = 0
            loadView.isHidden = false
            self.addSubview(loadView)
            return loadView
        }
        return nil
    }
    func showScreenLoading(noBackgroundColor:Bool = false)
    {
        guard let loadView = getScreenLoading() else {return}
        loadView.frame = self.bounds
        loadView.backgroundColor = noBackgroundColor ? UIColor.clear : UIColor.white
        loadView.loadType = .loading
        self.showLoading(loadView: loadView)
    }
    func showRetryLoading() {
        guard let loadView = getScreenLoading() else {return}
        loadView.frame = self.bounds
        loadView.backgroundColor = UIColor.white
        loadView.loadType = .retry
        
        self.showLoading(loadView: loadView)
    }
    func dismissScreenLoading()
    {
        guard let loadView = getScreenLoading() else {return}
        self.dismissLoading(loadView: loadView )
    }
    
    private func showLoading(loadView:ScreenLoadingView)
    {
        loadView.isHidden = false
        UIView.animate(withDuration: 0) {
            loadView.alpha = 1
        }
    }
    private func dismissLoading(loadView:ScreenLoadingView)
    {
        loadView.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            loadView.alpha = 0
        }) { _ in
            loadView.isHidden = true
        }
    }
}

class ScreenLoadingView: UIView {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryView: UIStackView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryLabel: UILabel!
  
    enum LoadType {
        case loading
        case retry
    }
    
    var isShow:Bool {
        return (self.superview != nil) && (self.isHidden == false)
    }
    
    
    private var _loadType:LoadType = .loading
    var loadType: LoadType {
        get { return _loadType }
        set { _loadType = newValue
            switch _loadType {
            case .loading:
                loadingIndicator.startAnimating()
                retryView.isHidden = true
                break
            case .retry:
                loadingIndicator.stopAnimating()
                retryView.isHidden = false
                break
            }
        }
    }
    
    func observeLoading<Element> (  _ api : Observable<Element> , shouldRetry: @escaping (Error)->Bool = { _ in return true } ,noBackgroundColor:Bool = false, noLoading:Bool = false) -> Observable< Element >
    {
        if self.superview == nil
        {
            fatalError("this view mush have superview")
        }
        let superView = self.superview!
        
        var loader = Observable.just( {
            }() )
            .flatMapLatest( { _ -> Observable<Element>  in
                if !noLoading {
                    superView.showScreenLoading(noBackgroundColor: noBackgroundColor)
                }
                
                return api
            } )
            .do(onNext: { _ in
                self.superview?.dismissScreenLoading()
            }, onError: { [unowned self] error in
                guard let k_error = error as? KError else {return}
                if shouldRetry(error)
                {
                    let errorMessage = k_error.getMessage
                    let code = " (\(toString( errorMessage.codeString )))"
                    self.retryLabel?.text = toString( errorMessage.message ) + code
                    debugError( toString( errorMessage.debugMessage ) + code )
                    self.superview?.showRetryLoading()
                }
                else {
                    self.superview?.dismissScreenLoading()
                }
            })
         loader = loader
            .retryWhen({ _ in
                return self.retryButton.rx.tap.flatMapLatest( {_ in return loader} )
            })
        
        return loader
    }
    
    
    func setCorner() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .topRight, cornerRadii: CGSize.init(width: 25.0, height: 25.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}



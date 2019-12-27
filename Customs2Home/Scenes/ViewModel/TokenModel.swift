//
//  CheckTokenViewModel.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 19/7/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class TokenModel  {
   
    static var obj_instance:TokenModel?
    
    static func instance() -> TokenModel{
        if obj_instance == nil {
            obj_instance = TokenModel()
        }
        return obj_instance!
    }
    
    func getValidToken() -> String?{
        return KeyChainService.refreshToken
    }
    
    func checkAccountValid() -> Bool{
        if self.getValidToken() != nil {
            return true
        }
        else{
            self.showLogin()
            return false
        }
    }
    
    func isLogin() -> Bool{
        if self.getValidToken() != nil {
            return true
        }
        return false
    }
    
    func showLogin()  {
        HomeTabbarViewModel.instance().showLogin()
    }
    
    static func showAlertForceLogin(msg:String){
        HomeTabbarViewModel.instance().showAlertForceLogin(msg)
    }
    
    static func clearTokenData() {
        KeyChainService.deleteAccessToken()
        KeyChainService.deleteRefreshToken()
        KeyChainService.deleteEmail()
        KeyChainService.deleteUserId()
    }
    
    

    func getRefreshToken() -> Observable<RefreshToken> {
        return GetRefreshTokenApi().callService(request: BaseRequestRefreshToken(refreshTokenReq: RefreshTokenReq() ))
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (resp) in
                guard let refreshTokenResp =  resp.refreshTokenResp else { return }
                KeyChainService.setAccessToken(AcsToken: refreshTokenResp.accessToken ?? "")
                KeyChainService.setRefreshToken(refToken: refreshTokenResp.refreshToken ?? "")
                print("Refresh Token Success")
            }, onError: { error in
                guard let k_error = error as? KError else { return  }
                let msg = k_error.getMessage.message ?? ""
                let code = k_error.getMessage.codeString ?? ""
                if code.contains("J006"){
                    TokenModel.clearTokenData()
                    TokenModel.showAlertForceLogin(msg: msg)
                }
            }
        )
    }
    
    func getLogout() -> Observable<Logout> {
        return GetLogoutApi().callService(request: BaseRequest())
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in
                TokenModel.clearTokenData()
            })
        }
    
}



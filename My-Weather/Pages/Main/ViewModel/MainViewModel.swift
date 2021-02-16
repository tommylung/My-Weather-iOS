//
//  MainViewModel.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class MainViewModel {
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    
    let psGotCityInfo = PublishSubject<(CityModel, Bool)>()
    
    // including current location city
    var strCurrentLocation: String?
    var arrCityString = [String]()
    var arrTrashString = [String]()
    
    // Getter
    func getCityInfo(lat dLat: Double, lon dLon: Double, isCurrentLocation bCurrentLocation: Bool = false) {
        var params = Parameters()
        params["lat"] = dLat
        params["lon"] = dLon
        params["limit"] = 1
        params["appid"] = AppGlobalManager.shared.appid
        self.psLoading.onNext(true)
        
        AF.request("https://api.openweathermap.org/geo/1.0/reverse", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let arrJson = json as? Array<NSDictionary> {
                    if let dictJson = arrJson.first {
                        self.psGotCityInfo.onNext((CityModel.parse(json: JSON(dictJson)), bCurrentLocation))
                    }
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getCityInfo(city strCity: String, isCurrentLocation bCurrentLocation: Bool = false) {
        var params = Parameters()
        params["q"] = strCity
        params["limit"] = 1
        params["appid"] = AppGlobalManager.shared.appid
        self.psLoading.onNext(true)
        
        AF.request("https://api.openweathermap.org/geo/1.0/direct", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let arrJson = json as? Array<NSDictionary> {
                    if let dictJson = arrJson.first {
                        self.psGotCityInfo.onNext((CityModel.parse(json: JSON(dictJson)), bCurrentLocation))
                    }
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
}

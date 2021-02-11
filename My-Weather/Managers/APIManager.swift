//
//  APIManager.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 11/2/2021.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class APIManager {
    static let  shared = APIManager()
    
    // Global
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    
    // Got
    let psGotCityInfo = PublishSubject<(CityModel, Bool)>()
    let psGotCitiesInfo = PublishSubject<[CityModel]>()
    let psGotCurrentWeather = PublishSubject<NSDictionary>()
    
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
    
    func getCitiesInfo(keyword strKeyword: String) {
        var params = Parameters()
        params["q"] = strKeyword
        params["limit"] = 20
        params["appid"] = AppGlobalManager.shared.appid
        self.psLoading.onNext(true)
        
        AF.request("http://api.openweathermap.org/geo/1.0/direct", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let arrDictionary = json as? Array<NSDictionary> {
                    var arrJson = [CityModel]()
                    arrDictionary.forEach {
                        arrJson.append(CityModel.parse(json: JSON($0)))
                    }
                    
                    self.psGotCitiesInfo.onNext(arrJson)
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getCurrentWeather(city strCity: String) {
        var params = Parameters()
        params["q"] = strCity
        params["appid"] = AppGlobalManager.shared.appid
        self.psLoading.onNext(true)
        
        AF.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let dictJson = json as? NSDictionary {
                    self.psGotCurrentWeather.onNext(dictJson)
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getCurrentWeather(lat dLat: Double, lon dLon: Double) {
        var params = Parameters()
        params["lat"] = dLat
        params["lon"] = dLon
        params["appid"] = AppGlobalManager.shared.appid
        self.psLoading.onNext(true)
        
        AF.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let dictJson = json as? NSDictionary {
                    self.psGotCurrentWeather.onNext(dictJson)
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        }
    }
}

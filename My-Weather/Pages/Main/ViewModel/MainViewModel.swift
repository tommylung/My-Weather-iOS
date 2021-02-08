//
//  MainViewModel.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import Alamofire
import CoreLocation
import Foundation
import RxSwift

class MainViewModel {
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psGotCurrentWeather = PublishSubject<(NSDictionary)>()
    
    // Getter
    func getCurrentWeather(city strCity: String) {
        var params = Parameters()
        params["q"] = strCity
        params["appid"] = AppGlobalManager.shared.appid
        
        AF.request("api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
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
        
        AF.request("api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
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
    
    // Get Current Location
    func getMyCurrentWeather() {
        
    }
}

//
//  WeatherTableViewModel.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 13/2/2021.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class WeatherTableViewModel {
    let psGotCity = PublishSubject<CityModel>()
    let psGotWeather = PublishSubject<CityWeatherModel>()
    
    func getLocation(city strCity: String) {
        var params = Parameters()
        params["q"] = strCity
        params["limit"] = 1
        params["appid"] = AppGlobalManager.shared.appid
        
        AF.request("https://api.openweathermap.org/geo/1.0/direct", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let arrDictionary = json as? Array<NSDictionary> {
                    var arrJson = [CityModel]()
                    arrDictionary.forEach {
                        arrJson.append(CityModel.parse(json: JSON($0)))
                    }
                    self.psGotCity.onNext(arrJson.first ?? CityModel())
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getWeather(city strCity: String) {
        var params = Parameters()
        params["q"] = strCity
        params["appid"] = AppGlobalManager.shared.appid
        params["units"] = "metric"
        
        AF.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let dictJson = json as? NSDictionary {
                    self.psGotWeather.onNext(CityWeatherModel.parse(json: JSON(dictJson)))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

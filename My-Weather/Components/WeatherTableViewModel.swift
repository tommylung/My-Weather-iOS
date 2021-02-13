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
    let psGotCurrentWeather = PublishSubject<CityWeatherModel>()
    
    func getCurrentWeather(city mCity: CityModel) {
        var params = Parameters()
        var strQ = ""
        if let strCity = mCity.name {
            strQ += strCity
        }
        if let strState = mCity.state {
            strQ += ",\(strState)"
        }
        if let strCountry = mCity.country {
            strQ += ",\(strCountry)"
        }
        params["q"] = strQ
        params["appid"] = AppGlobalManager.shared.appid
        params["units"] = "metric"
        
        AF.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let dictJson = json as? NSDictionary {
                    self.psGotCurrentWeather.onNext(CityWeatherModel.parse(json: JSON(dictJson)))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

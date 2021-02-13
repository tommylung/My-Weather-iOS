//
//  SearchViewModel.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 12/2/2021.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class SearchViewModel {
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    
    let psGotCitiesInfo = PublishSubject<[CityModel]>()
    
    var arrSearchedCity = [CityModel]()
    
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
}

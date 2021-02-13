//
//  CityModel.swift
//  My-Weather-AUS
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import Foundation
import SwiftyJSON

class CityModel: BaseModel {
    var name: String?
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?
    
    var isCurrent: Bool = false
    
    static func parse(json: JSON) -> CityModel {
        let obj = CityModel()
        obj.name = json["name"].stringValue
        obj.lat = json["lat"].doubleValue
        obj.lon = json["lon"].doubleValue
        obj.country = json["country"].stringValue
        obj.state = json["state"].stringValue
        return obj
    }
    
    func getCityString(withSpace bSpace: Bool = false) -> String {
        var str = ""
        if let strName = self.name {
            str += strName
        }
        if let strState = self.state, strState != "" {
            if bSpace {
                str += ", \(strState)"
            } else {
                str += ",\(strState)"
            }
        }
        if let strCountry = self.country, strCountry != "" {
            if bSpace {
                str += ", \(strCountry)"
            } else {
                str += ",\(strCountry)"
            }
        }
        
        return str
    }
}

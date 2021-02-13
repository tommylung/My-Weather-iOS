//
//  WeatherModel.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 13/2/2021.
//

import Foundation
import SwiftyJSON

class CityWeatherModel: BaseModel {
    var coord: CoordModel?
    var weather: [WeatherModel]?
    var base: String?
    var main: WeatherMainModel?
    var visibility: Int?
    
    static func parse(json: JSON) -> CityWeatherModel {
        let obj = CityWeatherModel()
        obj.coord = CoordModel.parse(json: json["coord"])
        obj.weather = WeatherModel.parseArray(jsonArray: json["weather"].arrayValue)
        obj.base = json["base"].stringValue
        obj.main = WeatherMainModel.parse(json: json["main"])
        obj.visibility = json["visibility"].intValue
        return obj
    }
}

class CoordModel: BaseModel {
    var lon: Double?
    var lat: Double?
    
    static func parse(json: JSON) -> CoordModel {
        let obj = CoordModel()
        obj.lon = json["lon"].doubleValue
        obj.lat = json["lat"].doubleValue
        return obj
    }
}

class WeatherModel: BaseModel {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    static func parse(json: JSON) -> WeatherModel {
        let obj = WeatherModel()
        obj.id = json["id"].intValue
        obj.main = json["main"].stringValue
        obj.description = json["description"].stringValue
        obj.icon = json["icon"].stringValue
        return obj
    }
}

class WeatherMainModel: BaseModel {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Double?
    var humidity: Double?
    
    static func parse(json: JSON) -> WeatherMainModel {
        let obj = WeatherMainModel()
        obj.temp = json["temp"].doubleValue
        obj.feelsLike = json["feels_like"].doubleValue
        obj.tempMin = json["temp_min"].doubleValue
        obj.tempMax = json["temp_max"].doubleValue
        obj.pressure = json["pressure"].doubleValue
        obj.humidity = json["humidity"].doubleValue
        return obj
    }
}



/*
 {
     "coord": {
         "lon": -0.1257,
         "lat": 51.5085
     },
     "weather": [
         {
             "id": 804,
             "main": "Clouds",
             "description": "overcast clouds",
             "icon": "04n"
         }
     ],
     "base": "stations",
     "main": {
         "temp": 269.3,
         "feels_like": 262.01,
         "temp_min": 268.71,
         "temp_max": 270.37,
         "pressure": 1033,
         "humidity": 68
     },
     "visibility": 10000,
     "wind": {
         "speed": 6.17,
         "deg": 100
     },
     "clouds": {
         "all": 100
     },
     "dt": 1613200610,
     "sys": {
         "type": 1,
         "id": 1414,
         "country": "GB",
         "sunrise": 1613200692,
         "sunset": 1613236286
     },
     "timezone": 0,
     "id": 2643743,
     "name": "London",
     "cod": 200
 }
 */

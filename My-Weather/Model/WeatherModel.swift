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
    var wind: WindModel?
    var clouds: CloudModel?
    var dt: Int?
    var sys: SystemModel?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    static func parse(json: JSON) -> CityWeatherModel {
        let obj = CityWeatherModel()
        obj.coord = CoordModel.parse(json: json["coord"])
        obj.weather = WeatherModel.parseArray(jsonArray: json["weather"].arrayValue)
        obj.base = json["base"].stringValue
        obj.main = WeatherMainModel.parse(json: json["main"])
        obj.visibility = json["visibility"].intValue
        obj.wind = WindModel.parse(json: json["wind"])
        obj.clouds = CloudModel.parse(json: json["clouds"])
        obj.dt = json["dt"].intValue
        obj.sys = SystemModel.parse(json: json["sys"])
        obj.timezone = json["timezone"].intValue
        obj.id = json["id"].intValue
        obj.name = json["name"].stringValue
        obj.cod = json["cod"].intValue
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
    var pressure: Int?
    var humidity: Double?
    
    static func parse(json: JSON) -> WeatherMainModel {
        let obj = WeatherMainModel()
        obj.temp = json["temp"].doubleValue
        obj.feelsLike = json["feels_like"].doubleValue
        obj.tempMin = json["temp_min"].doubleValue
        obj.tempMax = json["temp_max"].doubleValue
        obj.pressure = json["pressure"].intValue
        obj.humidity = json["humidity"].doubleValue
        return obj
    }
}

class WindModel: BaseModel {
    var speed: Double?
    var deg: Int?
    
    static func parse(json: JSON) -> WindModel {
        let obj = WindModel()
        obj.speed = json["speed"].doubleValue
        obj.deg = json["deg"].intValue
        return obj
    }
}

class CloudModel: BaseModel {
    var all: Int?
    
    static func parse(json: JSON) -> CloudModel {
        let obj = CloudModel()
        obj.all = json["all"].intValue
        return obj
    }
}

class SystemModel: BaseModel {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    
    static func parse(json: JSON) -> SystemModel {
        let obj = SystemModel()
        obj.type = json["type"].intValue
        obj.id = json["id"].intValue
        obj.country = json["country"].stringValue
        obj.sunrise = json["sunrise"].intValue
        obj.sunset = json["sunset"].intValue
        return obj
    }
}

//
//  CityDetailViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 13/2/2021.
//

import RxSwift
import UIKit

class CityDetailViewController: UIViewController {

    var vm = CityDetailViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTempurature: UILabel!
    @IBOutlet weak var vWeatherContainer: UIView!
    @IBOutlet weak var imgvWeather: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var vTempMin: UIView!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var vTempMax: UIView!
    @IBOutlet weak var lblTempMax: UILabel!
    @IBOutlet weak var vFeelsLike: UIView!
    @IBOutlet weak var lblFeelsLike: UILabel!
    @IBOutlet weak var vPressure: UIView!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var vHumidity: UIView!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var vWindSpeed: UIView!
    @IBOutlet weak var lblWindSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }

    // MARK: - Core
    private func initUI() {
        self.lblCity.isHidden = true
        self.lblCity.text = ""
        self.lblTempurature.isHidden = true
        self.lblTempurature.text = ""
        self.vWeatherContainer.isHidden = true
        self.imgvWeather.image = nil
        self.lblDesc.isHidden = true
        self.lblDesc.text = ""
        self.vTempMin.isHidden = true
        self.lblTempMin.text = ""
        self.vTempMax.isHidden = true
        self.lblTempMax.text = ""
        self.vFeelsLike.isHidden = true
        self.lblFeelsLike.text = ""
        self.vPressure.isHidden = true
        self.lblPressure.text = ""
        self.vHumidity.isHidden = true
        self.lblHumidity.text = ""
        self.vWindSpeed.isHidden = true
        self.lblWindSpeed.text = ""
    }
    
    private func bindUI() {
        self.vm.psGotWeather.subscribe(onNext: { [weak self] mCityWeather in
            guard let self = self else { return }
            if var strName = mCityWeather.name {
                if let strCountry = mCityWeather.sys?.country {
                    strName = "\(StringUtils.getFlagEmoji(country: strCountry)) \(strName)"
                }
                self.lblCity.text = strName
                self.lblCity.isHidden = false
            }
            if let mWeather = mCityWeather.weather?.first {
                if let strIcon = mWeather.icon {
                    self.imgvWeather.requestImage(url: "http://openweathermap.org/img/wn/\(strIcon)@2x.png")
                    self.vWeatherContainer.isHidden = false
                }
                if let strMain = mWeather.main {
                    var str = strMain
                    if let strDescription = mWeather.description {
                        str += "\n\(strDescription)"
                    }
                    self.lblDesc.text = str
                    self.lblDesc.isHidden = false
                }
            }
            if let mMain = mCityWeather.main {
                if let dTemp = mMain.temp {
                    self.lblTempurature.text = "\(Int(dTemp))°C"
                    self.lblTempurature.isHidden = false
                }
                if let dFeelsLike = mMain.feelsLike {
                    self.lblFeelsLike.text = "\(Int(dFeelsLike))°C"
                    self.vFeelsLike.isHidden = false
                }
                if let dTempMin = mMain.tempMin {
                    self.lblTempMin.text = "\(Int(dTempMin))°C"
                    self.vTempMin.isHidden = false
                }
                if let dTempMax = mMain.tempMax {
                    self.lblTempMax.text = "\(Int(dTempMax))°C"
                    self.vTempMax.isHidden = false
                }
                if let iPressure = mMain.pressure {
                    self.lblPressure.text = "\(iPressure) Pa"
                    self.vPressure.isHidden = false
                }
                if let dHumidity = mMain.humidity {
                    self.lblHumidity.text = "\(Int(dHumidity))%"
                    self.vHumidity.isHidden = false
                }
            }
            if let mWind = mCityWeather.wind {
                if let dSpeed = mWind.speed {
                    self.lblWindSpeed.text = "\(dSpeed) km/h"
                    self.vWindSpeed.isHidden = false
                }
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        if let strCity = self.vm.strCity {
            self.vm.getWeather(city: strCity)
        }
    }

}

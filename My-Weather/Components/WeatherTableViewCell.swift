//
//  WeatherTableViewCell.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import RxSwift
import UIKit

class WeatherTableViewCell: UITableViewCell {

    var vm = WeatherTableViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var vWeatherContainer: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var imgvNavigation: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgvTemp: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.bindUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initUI()
        self.bindUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Core
    private func initUI() {
        self.disposeBag = DisposeBag()
        
        self.vWeatherContainer.backgroundColor = AppGlobalManager.shared.colorTheme
        self.lblCity.text = ""
        self.imgvNavigation.isHidden = true
        self.lblTemp.text = ""
        self.imgvTemp.image = nil
    }
    
    private func bindUI() {
        self.vm.psGotCity.subscribe(onNext: { [weak self] city in
            guard let self = self else { return }
            if let name = city.name {
                self.lblCity.text = name
            }
        }).disposed(by: self.disposeBag)
        
        self.vm.psGotWeather.subscribe(onNext: { [weak self] cityWeather in
            guard let self = self else { return }
            if let temp = cityWeather.main?.temp {
                self.lblTemp.text = "\(Int(temp))°C"
            } else{
                self.lblTemp.text = ""
            }
            if let weatherIcon = cityWeather.weather?.first?.icon {
                self.imgvTemp.requestImage(url: "http://openweathermap.org/img/wn/\(weatherIcon)@2x.png")
            }
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Update UI
    func updateUI(city mCity: CityModel) {
        self.lblCity.text = mCity.name
        self.imgvNavigation.isHidden = !mCity.isCurrent
    }
}

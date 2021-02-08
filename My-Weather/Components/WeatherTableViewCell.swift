//
//  WeatherTableViewCell.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import RxSwift
import UIKit

class WeatherTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgvTemp: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Core
    private func initUI() {
        self.disposeBag = DisposeBag()
        
        self.lblCity.text = ""
        self.lblTemp.text = ""
        self.imgvTemp.image = nil
    }
}

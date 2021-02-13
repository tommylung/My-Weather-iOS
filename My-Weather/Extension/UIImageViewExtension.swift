//
//  UIImageViewExtension.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 13/2/2021.
//

import AlamofireImage
import UIKit

extension UIImageView {
    
    func requestImage(url strImageUrl: String? = nil) {
        if let strImageUrl = strImageUrl, let urlImage = URL(string: strImageUrl) {
            let data = try! Data(contentsOf: urlImage)
            self.image = UIImage(data: data)
        }
    }
    
}

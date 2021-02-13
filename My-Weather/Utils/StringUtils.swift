//
//  StringUtils.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 13/2/2021.
//

import Foundation

struct StringUtils {
    public static func getFlagEmoji(country: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}

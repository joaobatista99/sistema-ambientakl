//
//  String+Extensions.swift
//  sistema-ambiental
//
//  Created by João Victor Batista on 26/11/23.
//

import Foundation

extension String {
    
    func doubleValue(localeID: String = "pt_BR") -> Double? {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: localeID)
        let number = nf.number(from: self)
        return number?.doubleValue
    }
}

//
//  DecimalTextProcessing.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import Foundation

protocol DecimalTextProcessing {
    init(allowsNegativeNumbers: Bool)
    mutating func process(_ text: String) -> String
}

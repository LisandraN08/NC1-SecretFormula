//
//  Item.swift
//  NC1-SecretFormula
//
//  Created by Lisandra Nicoline on 25/04/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

//
//  ViewModelDetails.swift
//  MVVM
//
//  Created by Nimol on 21/11/23.
//

import Foundation
class ViewModelDetails {
    var model: Model
    var name: String?
    var price: Double?
    var image: String?
    
    init(model: Model) {
        self.model = model
        self.name = model.name
        self.price = model.price
        self.image = model.image
    }
}

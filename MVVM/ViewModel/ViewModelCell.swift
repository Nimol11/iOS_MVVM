//
//  ViewModelCell.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//

import Foundation
class ViewModelCell {    
    
    var name: String?
    var price: Double?
    var image: String?
    
    init(model: Model) {
        self.name = model.name
        self.price = model.price
        self.image = model.image
    }
}

//
//  CollectionViewCell.swift
//  Json
//
//  Created by Nimol on 20/11/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CollectionViewCell"
    static let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    func setUpCell(viewModel: ViewModelCell) {
        self.name.text = viewModel.name 
        self.price.text = String(viewModel.price ?? 0.0)
        self.imageView.downloadImage(ulrAddress: viewModel.image ?? "")
    }
}

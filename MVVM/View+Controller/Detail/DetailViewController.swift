//
//  DetailViewController.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var zero: RoundUIView!
    @IBOutlet weak var twenty: RoundUIView!
    @IBOutlet weak var fifty: RoundUIView!
    @IBOutlet weak var seventy: RoundUIView!
    @IBOutlet weak var hundred: RoundUIView!
    @IBOutlet weak var oneTwenty: RoundUIView!
    @IBOutlet weak var small: RoundUIView!
    @IBOutlet weak var medium: RoundUIView!
    @IBOutlet weak var large: RoundUIView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var totalPrice: UILabel!
    
    var viewModelDetail: ViewModelDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configType()
        stepper.minimumValue = 0
        stepper.maximumValue = 20
         setUpView()
      
    }
    private func configType() {
        zero.setOnClickListener { [self] in
            zero.backgroundColor = .cyan
            twenty.backgroundColor = .white
            fifty.backgroundColor = .white
            seventy.backgroundColor = .white
            hundred.backgroundColor = .white
            oneTwenty.backgroundColor = .white
        }
        twenty.setOnClickListener { [self] in
            zero.backgroundColor = .white
            twenty.backgroundColor = .cyan
            fifty.backgroundColor = .white
            seventy.backgroundColor = .white
            hundred.backgroundColor = .white
            oneTwenty.backgroundColor = .white
        }
        fifty.setOnClickListener { [self] in
            zero.backgroundColor = .white
            twenty.backgroundColor = .white
            fifty.backgroundColor = .cyan
            seventy.backgroundColor = .white
            hundred.backgroundColor = .white
            oneTwenty.backgroundColor = .white
        }
        seventy.setOnClickListener { [self] in
            zero.backgroundColor = .white
            twenty.backgroundColor = .white
            fifty.backgroundColor = .white
            seventy.backgroundColor = .cyan
            hundred.backgroundColor = .white
            oneTwenty.backgroundColor = .white
        }
        hundred.setOnClickListener { [self] in
            zero.backgroundColor = .white
            twenty.backgroundColor = .white
            fifty.backgroundColor = .white
            seventy.backgroundColor = .white
            hundred.backgroundColor = .cyan
            oneTwenty.backgroundColor = .white
        }
        oneTwenty.setOnClickListener { [self] in
            zero.backgroundColor = .white
            twenty.backgroundColor = .white
            fifty.backgroundColor = .white
            seventy.backgroundColor = .white
            hundred.backgroundColor = .white
            oneTwenty.backgroundColor = .cyan
        }
        small.setOnClickListener { [self] in
            small.backgroundColor = .cyan
            medium.backgroundColor = .white
            large.backgroundColor = .white
        }
        medium.setOnClickListener { [self] in
            medium.backgroundColor = .cyan
            small.backgroundColor = .white
            large.backgroundColor = .white
        }
        large.setOnClickListener { [self] in
            large.backgroundColor = .cyan
            small.backgroundColor = .white
            medium.backgroundColor = .white
            
        }
    }
    private func setUpView() {
        guard let viewModelDetail = viewModelDetail else {return}
        imageView.downloadImage(ulrAddress: (viewModelDetail.image)!)
        name.text = viewModelDetail.name
        price.text = String(viewModelDetail.price ?? 0)
        
    }
    func getData(viewModel: ViewModelDetails) {
        self.viewModelDetail = viewModel
    }
    @IBAction func selectQuantity(_ sender: Any) {
        let quan: Int = Int(stepper.value)
        quantity.text = String(quan)
        let total = stepper.value * (viewModelDetail?.price ?? 0.0)
        totalPrice.text = "\(String(format: "%.2f", total)) $"
    }
    @IBAction func selectSugar(_ sender: UISlider) {
      
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

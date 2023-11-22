//
//  Extension.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//


import UIKit

extension UIImageView {
    func downloadImage(ulrAddress: String) {
        if let url = URL(string: ulrAddress) {
            let activityIndicator = UIActivityIndicatorView()
                   activityIndicator.hidesWhenStopped = true
                   activityIndicator.color = UIColor.red
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.startAnimating()         
            self.addSubview(activityIndicator)
            self.image =  nil
            URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
                guard let data = dataResponse else {return}
                DispatchQueue.main.async {
                    if !data.isEmpty {
                        activityIndicator.stopAnimating()
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()  
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
       
    }
}

class ClickListener: UITapGestureRecognizer {
   var onClick : (() -> Void)? = nil
  }
extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
     
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
     
}

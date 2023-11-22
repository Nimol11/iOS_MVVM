//
//  ViewModel.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//

import Foundation

class ViewModel {
    
    var dataSource: [Model]?
    var dataCell: Observable<[ViewModelCell]> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)

    func numberOfSection() -> Int{
        1
    }
    func numberOfRows(in section: Int) -> Int {
        self.dataSource?.count ?? 0
    }
    func getData() {
        print("Get Data")
        Service.getProduct { [weak self] result in
            self!.isLoading.value = false
            switch result {
            case .success(let data ):
              
                self?.dataSource = data
                self?.mapCelldata()
                
            case .failure(let error ):
                print("=======> \(error)")
                self!.isLoading.value = true
            }
        }
    }
    func mapCelldata () {
        self.dataCell.value = self.dataSource?.compactMap({ViewModelCell(model: $0)})
    }   
    func retrive(with name: String) -> Model? {
        guard let model = dataSource?.first(where: {$0.name == name}) else {
            return nil
        }
        return model
    }
}

//
//  ViewController.swift
//  Json
//
//  Created by Nimol on 20/11/23.
//

import UIKit
import Combine
class ViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private let pullRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(nil, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "internet")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ViewModel = ViewModel()
    var model: [ViewModelCell]  = []
    private var refreshTime = 0
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        bindViewModel()
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        view.addSubview(imageView)
        imageView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    override func viewDidLayoutSubviews() {
        imageView.frame = view.frame
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
        ])
    }
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(pullRefresh)
    }
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] loading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if loading! {
                    print("No data")
                    if self.refreshTime == 0 {
                        self.networkConnection()
                    } else {
                        self.imageView.isHidden = false
                        self.activityIndicator.stopAnimating()
                        self.view.backgroundColor = .red
                        self.collectionView.isHidden = true
                    }
                } else {
                    print("data")
                }
            }
        }
        viewModel.dataCell.bind { [weak self] data in
            guard let self = self ,let data = data else  {
                return
            }
            if data.isEmpty {
                networkConnection()
            } else {
                self.model = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.pullRefresh.endRefreshing()
                }
            }
        }
    }
    @objc func refreshData() {
        viewModel.getData()
    }
    private func networkConnection() {
        let alert = UIAlertController(title: "No Internet Connection", message: "You are not connect to the internet. \n make sure inetenet or wifi is on, aiplane mode is off", preferredStyle: .alert)
        let retry = UIAlertAction(title: "Try agian", style: .default) { action in
            self.viewModel.getData()
            self.refreshTime = 1
        }
        alert.addAction(retry)
        present(alert, animated: true)
    }
}
//MARK: Data source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = self.model[indexPath.row]
        cell.setUpCell(viewModel: index)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

//
//  ViewController.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//

import UIKit

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
        setUpConstraint()
    }
    
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(pullRefresh)
    }
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] loading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if loading! {
                    if self.refreshTime == 0 {
                        self.networkConnection()
                    } else {
                        self.imageView.isHidden = false
                        self.activityIndicator.stopAnimating()
                        self.view.backgroundColor = .red
                        self.collectionView.isHidden = true
                    }
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
    private func networkConnection() {
        let alert = UIAlertController(title: "No Internet Connection", message: "You are not connect to the internet. \n make sure inetenet or wifi is on, aiplane mode is off", preferredStyle: .alert)
        let retry = UIAlertAction(title: "Try agian", style: .default) { action in
            self.viewModel.getData()
            self.refreshTime = 1
        }
        alert.addAction(retry)
        present(alert, animated: true)
    }
    @objc func refreshData() {
        viewModel.getData()
    }
    func openDetail(withName: String) {
        guard let model = viewModel.retrive(with: withName) else {
            return
        }
        let viewModelDetail = ViewModelDetails(model: model)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.getData(viewModel: viewModelDetail)
        self.present(vc!, animated: true)
    }
    private func setUpConstraint() {
        imageView.frame = view.frame
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: Data source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSection()
    }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let index = model[indexPath.row].name else {
            return
        }
        openDetail(withName: index)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

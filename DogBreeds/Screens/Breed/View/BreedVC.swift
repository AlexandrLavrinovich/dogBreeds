//
//  BreedVC.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

protocol BreedVMProtocol: AnyObject {
    var cells: [BreedCellVMProtocol] { get set }
    var breedName: String { get }
    var delegate: BreedVMDelegate? { get set }
    func getFavouriteCells()
    func getList(breedName: String)
    func changeLike(url: String, name: String, liked: Bool)
}

class BreedVC: UIViewController, Stringable {
    
    
    private let viewModel: BreedVMProtocol
    private let factory: BreedFactoryProtocol
    private var row = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    init(viewModel: BreedVMProtocol, factory: BreedFactoryProtocol) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: Self.string, bundle: nil)
        viewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupDataConfiguration()
        setupUI()
        
    }
    
}



private extension BreedVC {
    
    func setupDataConfiguration() {
        viewModel.getList(breedName: viewModel.breedName)
        viewModel.getFavouriteCells()
    }
    
    func setupUI() {
        let shareButton = UIBarButtonItem(title: "share", style: .done, target: self, action: #selector(share(_:)))
        self.navigationController?.navigationBar.sizeToFit()
        self.navigationItem.rightBarButtonItem = shareButton
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: BreedCell.string, bundle: nil), forCellWithReuseIdentifier: BreedCell.string)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func setupShareButton() {
        
    }
    
    @objc func share(_ sender: UIBarButtonItem ) {
        let url = viewModel.cells[row].url
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activity, animated: true)
    }
    
}


//MARK: - BreedVCDelegae
extension BreedVC: BreedVMDelegate {
    
    func showError(_ text: String) {
        print(text)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func reloadRow(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}



//MARK: - UICollectionViewDataSource
extension BreedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.cells.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.string, for: indexPath) as? BreedCell else { return UICollectionViewCell() }
        cell.update(with: viewModel.cells[indexPath.row], viewModelDelegate: viewModel)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            print(indexPath.row)
            self.row = indexPath.row
        }
    }
}



//MARK: - UICollectionViewDelegae
extension BreedVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("works")
    }
}

//MARK: - UICollctionViewDelegateFlowLayout
extension BreedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.superview?.frame.width ?? 100)
        let barHeight = self.navigationController?.navigationBar.frame.height ?? 30
        let height = collectionView.superview?.safeAreaLayoutGuide.layoutFrame.height ?? 200
        let totalHeight = height - barHeight
        return CGSize(width: width, height: totalHeight)
    }
}

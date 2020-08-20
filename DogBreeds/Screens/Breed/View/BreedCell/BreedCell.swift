//
//  BreedCell.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

class BreedCell: UICollectionViewCell, Stringable {
    
    @IBOutlet weak var imageBreed: UIImageView!
    @IBOutlet weak var bookMark: UIButton!
    
    private var delegete: BreedVMProtocol?
    
    
    @IBAction func tapBookmark(_ sender: Any) {
        guard let viewModel = viewModel else { return }
//        delegete?.removeLike(name: viewModel.name, url: viewModel.url)
        if viewModel.liked {
            delegete?.changeLike(url: viewModel.url, name: viewModel.name, liked: false)
        } else {
            delegete?.changeLike(url: viewModel.url, name: viewModel.name, liked: true)
            
        }
    }
    
    
    private(set) var viewModel: BreedCellVMProtocol?
    
    func update(with viewModel: BreedCellVMProtocol, viewModelDelegate: BreedVMProtocol) {
        self.viewModel = viewModel
        self.delegete = viewModelDelegate
        self.setupVM(cellVM: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

private extension BreedCell {
    func setupVM(cellVM: BreedCellVMProtocol?) {
        guard let viewModel = cellVM else { return }
        imageBreed.loadImage(fromURL: viewModel.url, with: UIImage(imageLiteralResourceName: "defImage"))
        if viewModel.liked {
            bookMark.imageView?.image = UIImage(imageLiteralResourceName: "liked")
        } else {
            bookMark.imageView?.image = UIImage(imageLiteralResourceName: "notLiked")
        }
    }
}

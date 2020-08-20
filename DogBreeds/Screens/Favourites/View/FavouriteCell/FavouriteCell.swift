//
//  FavouriteCell.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

class FavouriteCell: UITableViewCell, Stringable {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    
    private(set) var viewModel: FavouriteCellVMProtocol?
    
    func update(with viewModel: FavouriteCellVMProtocol) {
        self.viewModel = viewModel
        setupVM(cellVM: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

private extension FavouriteCell {
    func setupVM(cellVM: FavouriteCellVMProtocol?) {
        guard let viewModel = cellVM else { return }
        name.text  = viewModel.name
        if viewModel.count == 0 {
            count.text = "(0 понравившихся)"
        } else {
            count.text = "(\(viewModel.count) фотографии)"
        }
    }
}

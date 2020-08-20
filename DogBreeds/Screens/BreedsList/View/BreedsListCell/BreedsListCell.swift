//
//  BreedsListCell.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

class BreedsListCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var count: UILabel!
    
    private(set) var viewModel: BreedsListCellVMProtocol?
    
    func update(with viewModel: BreedsListCellVMProtocol) {
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

private extension BreedsListCell {
    func setupVM(cellVM: BreedsListCellVMProtocol?) {
        guard let viewModel = cellVM else { return }
        name.text = viewModel.name
        if viewModel.count == 0 {
            count.text = ""
        } else {
            count.text = "\(viewModel.count) (подпород)"
        }
    }
}

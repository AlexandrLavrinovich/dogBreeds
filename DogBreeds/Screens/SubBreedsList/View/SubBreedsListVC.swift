//
//  SubBreedsListVC.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 18.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

protocol SubBreedsListVMProtocol: AnyObject {
    var cells: [BreedsListCellVMProtocol] { get set }
    var delegate: SubBreedsListVMDelegate? { get set }
    func getList()
    func didSelectRow(at indexPath: IndexPath)
}


class SubBreedsListVC: UIViewController, Stringable {
    
    // MARK: - Inputs
    private let viewModel: SubBreedsListVMProtocol
    private let factory: SubBreedsListFactoryProtocol
    
    
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: SubBreedsListVMProtocol, factory: SubBreedsListFactoryProtocol) {
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

private extension SubBreedsListVC {
    
    func setupDataConfiguration() {
        viewModel.getList()
    }
    
    func setupUI() {
        navigationController?.navigationBar.sizeToFit()
        tableView.register(UINib(nibName: BreedsListCell.string, bundle: nil), forCellReuseIdentifier: BreedsListCell.string)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 58
        tableView.dataSource = self
        tableView.delegate = self
    }
}


//MARK: - SubBreedsListVMDelegate
extension SubBreedsListVC: SubBreedsListVMDelegate {
    func openBreed(breedName: String) {
        let vc = BreedFactory().makeVC(breedName: breedName)
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - UITablViewDataSource
extension SubBreedsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedsListCell.string, for: indexPath) as? BreedsListCell else { return UITableViewCell() }
        cell.update(with: viewModel.cells[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//MARK: - UITableViewDelegate
extension SubBreedsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

//
//  FavouriteVC.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

protocol FavouriteVMProtocol: AnyObject {
    var cells: [FavouriteCellVMProtocol] { get set }
    var delegate: FavouriteVMDelegate? { get set }
    func getList()
    func didSelectRow(at indexPath: IndexPath)
}

class FavouriteVC: UIViewController, Stringable {
    
    
    private let viewModel: FavouriteVMProtocol
    private let factory: FavouriteFactoryProtocol
    
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: FavouriteVMProtocol, factory: FavouriteFactoryProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        setupDataConfiguration()
        setupUI()
    }
    
}

private extension FavouriteVC {
    func setupDataConfiguration() {
        viewModel.getList()
    }
    
    func setupUI() {
        navigationController?.navigationBar.sizeToFit()
        tableView.register(UINib(nibName: FavouriteCell.string, bundle: nil), forCellReuseIdentifier: FavouriteCell.string)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 58
        tableView.dataSource = self
        tableView.delegate = self
    }
}



//MARK: - FavouriteVMDelegate
extension FavouriteVC: FavouriteVMDelegate {
    func showError(_ text: String) {
        print(text)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func openBreed(urls: [String], breedName: String) {
        let vc = BreedFactory().makeFavouriteVC(urls: urls, breedName: breedName)
        navigationController?.pushViewController(vc, animated: true)
    }
}



//MARK: - UITableViewDataSource
extension FavouriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.string, for: indexPath) as? FavouriteCell else { return UITableViewCell() }
        cell.update(with: viewModel.cells[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}



// MARK: - UITableViewDelegate
extension FavouriteVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

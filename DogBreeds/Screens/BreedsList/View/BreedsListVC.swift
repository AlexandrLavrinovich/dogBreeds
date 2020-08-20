//
//  BreedsListVC.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation
import UIKit

protocol BreedsListVMProtocol: AnyObject {
    var cells: [BreedsListCellVMProtocol] { get set }
    var delegate: BreedsListVMDelegate? { get set }
    func getList()
    func didSelectRow(at indexPath: IndexPath)
}

class BreedsListVC: UIViewController, Stringable {
    
    private let viewModel: BreedsListVMProtocol
    private let factory: BreedsListFactoryProtocol
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init(viewModel: BreedsListVMProtocol, factory: BreedsListFactoryProtocol) {
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

private extension BreedsListVC {
    
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



//MARK: - BreedsListVCDelegate
extension BreedsListVC: BreedsListVMDelegate {
    
    func openBreedList(breed: String, subBreeds: [String]?) {
        let vc = SubBreedsListFactory().makeVC(breed: breed, subBreeds: subBreeds)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openBreed(breedName: String) {
        let vc = BreedFactory().makeVC(breedName: breedName)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ text: String) {
        print(text)
    }
    
    func indicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.color = .black
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}



//MARK: - UITableViewDataSource
extension BreedsListVC: UITableViewDataSource {
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



// MARK: - UITableViewDelegate
extension BreedsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}



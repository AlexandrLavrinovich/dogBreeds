//
//  MainTabBarVC.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        let firstVC = BreedsListFactory().makeVC()
        firstVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let secondVC = FavouriteFactory().makeVC()
        secondVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let tabBarList = [firstVC, secondVC]
        self.viewControllers = tabBarList
    }
    
}

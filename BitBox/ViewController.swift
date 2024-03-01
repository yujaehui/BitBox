//
//  ViewController.swift
//  BitBox
//
//  Created by Jaehui Yu on 3/1/24.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.white
        self.tabBar.tintColor = ColorStyle.purple
        addVC()
    }

    private func addVC() {
        let trendVC = UINavigationController(rootViewController: TrendViewController())
        trendVC.tabBarItem = UITabBarItem(title: "trend", image: ImageStyle.trendInactive, selectedImage: ImageStyle.trend)
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "search", image: ImageStyle.searchInactive, selectedImage: ImageStyle.search)
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "favorite", image: ImageStyle.favoriteInactive, selectedImage: ImageStyle.favorite)
        
        let userVC = UINavigationController(rootViewController: UserViewController())
        userVC.tabBarItem = UITabBarItem(title: "user", image: ImageStyle.userInactive, selectedImage: ImageStyle.user)
        
        self.viewControllers = [trendVC, searchVC, favoriteVC, userVC]
    }
}

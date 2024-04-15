//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 06.04.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let tabBar = UITabBar.appearance()
        tabBar.backgroundColor = .trWhite
        tabBar.tintColor = .trBlue
        
        let font = UIFont.systemFont(ofSize: 10, weight: .medium)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: nil)
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }
}

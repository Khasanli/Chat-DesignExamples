//
//  MainViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 02.07.21.
//

import UIKit

import UIKit
class MainViewController: TabBarController {

    override func loadView() {
        super.loadView()
        TabBarSetting.tabBarTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        TabBarSetting.tabBarCircleSize = CGSize(width: 60, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.delegate = self
        
        let vc1 = HomeViewController()
        let vc2 = ChatViewController()
        let vc3 = ProfileViewController()
        let vc4 = SettingViewController()
                
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_Selected"))
        vc2.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat_Selected"))
        vc3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile_Selected"))
        vc4.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting"), selectedImage: UIImage(named: "setting_Selected"))
           
        viewControllers = [vc1, vc2, vc3, vc4]
    }
    
}

extension MainViewController: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelect viewController: UIViewController) {
    }
}



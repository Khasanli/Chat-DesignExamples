//
//  TabbarViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//

import UIKit

public protocol TabBarControllerDelegate: NSObjectProtocol {
    func tabBarController(_ tabBarController: TabBarController, didSelect viewController: UIViewController)
}

open class TabBarController: UIViewController, TabBarDelegate {
    
    weak open var delegate: TabBarControllerDelegate?
    
    public var selectedIndex: Int = 0
    public var previousSelectedIndex = 0
    
    public var viewControllers = [UIViewController]() {
        didSet {
            tabBar.viewControllers = viewControllers
        }
    }
    
    private lazy var tabBar: TabBar = {
        let tabBar = TabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        self.view.addSubview(tabBar)
        self.view.bringSubviewToFront(tabBar)
        self.drawConstraint()
    }
    
    private func drawConstraint() {
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.backgroundColor = TabBarSetting.tabBarBackground
        self.view.addSubview(safeAreaView)
        self.view.bringSubviewToFront(safeAreaView)
        var constraints = [NSLayoutConstraint]()
        if #available(iOS 11.0, *) {
            constraints += [containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(TabBarSetting.tabBarHeight)),
                            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        } else {
            constraints += [containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(TabBarSetting.tabBarHeight)),
                            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        }
        constraints += [containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        containerView.topAnchor.constraint(equalTo: view.topAnchor),
                        tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        tabBar.heightAnchor.constraint(equalToConstant: TabBarSetting.tabBarHeight),
                        safeAreaView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
                        safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    func tabBar(_ tabBar: TabBar, didSelectTabAt index: Int) {
        
        let previousVC = viewControllers[index]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        previousSelectedIndex = selectedIndex
        
        let vc = viewControllers[index]
        delegate?.tabBarController(self, didSelect: vc)
        addChild(vc)
        selectedIndex = index + 1
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
}

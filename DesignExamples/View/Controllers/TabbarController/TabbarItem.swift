//
//  TabbarItem.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//

import UIKit

class TabBarItem: UIView {
    
    let image: UIImage
    let title: String
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.title
        lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        lbl.textColor = UIColor.darkGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var tabImageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(tabBarItem item: UITabBarItem) {
        guard let selecteImage = item.image else {
            fatalError("You should set image to all view controllers")
        }
        self.image = selecteImage
        self.title = item.title ?? ""
        super.init(frame: .zero)
        drawConstraints()
    }
    
    private func drawConstraints() {
        self.addSubview(titleLabel)
        self.addSubview(tabImageView)
        NSLayoutConstraint.activate([
            tabImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tabImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tabImageView.heightAnchor.constraint(equalToConstant: TabBarSetting.tabBarSizeImage),
            tabImageView.widthAnchor.constraint(equalToConstant: TabBarSetting.tabBarSizeImage),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: TabBarSetting.tabBarHeight),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   internal func animateTabSelected() {
        tabImageView.alpha = 1
        titleLabel.alpha = 0
        UIView.animate(withDuration: TabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.frame.origin.y = TabBarSetting.tabBarHeight / 1.8
            self?.tabImageView.frame.origin.y = -5
            self?.tabImageView.alpha = 0
        }
    }
    
    internal func animateTabDeSelect() {
        tabImageView.alpha = 1
        UIView.animate(withDuration: TabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.titleLabel.frame.origin.y = TabBarSetting.tabBarHeight
            self?.tabImageView.frame.origin.y = (TabBarSetting.tabBarHeight / 2) - CGFloat(TabBarSetting.tabBarSizeImage / 2)
            self?.tabImageView.alpha = 1
        }
    }
}

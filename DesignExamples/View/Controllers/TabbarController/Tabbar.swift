//
//  Tabbar.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//Copyright (c) 2020 Ahmadalsofi <alsofiahmad@yahoo.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.


import UIKit

// use this protocol to detect when a tab bar item is pressed
protocol TabBarDelegate: AnyObject {
     func tabBar(_ tabBar: TabBar, didSelectTabAt index: Int)
}

public class TabBar: UIView {
    
   internal var viewControllers = [UIViewController]() {
        didSet {
            drawTabs()
            guard !viewControllers.isEmpty else { return }
            drawConstraint()
            layoutIfNeeded()
            didSelectTab(index: 0)
        }
    }
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let innerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = TabBarSetting.tabBarBackground
        return view
    }()
    
    private let outerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = TabBarSetting.tabBarTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tabSelectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    weak var delegate: TabBarDelegate?
    
    private var selectedIndex: Int = 0
    private var previousSelectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dropShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dropShadow()
    }
    
    private func dropShadow() {
        backgroundColor = TabBarSetting.tabBarBackground
        layer.shadowColor = TabBarSetting.tabBarShadowColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 3
    }
    
    private func drawTabs() {
        for vc in viewControllers {
            let barView = TabBarItem(tabBarItem: vc.tabBarItem)
            barView.heightAnchor.constraint(equalToConstant: TabBarSetting.tabBarHeight).isActive = true
            barView.translatesAutoresizingMaskIntoConstraints = false
            barView.isUserInteractionEnabled = false
            self.stackView.addArrangedSubview(barView)
        }
    }
    
    private func drawConstraint() {
        addSubview(stackView)
        addSubview(innerCircleView)
      
        innerCircleView.addSubview(outerCircleView)
        outerCircleView.addSubview(tabSelectedImageView)
        
        innerCircleView.frame.size = TabBarSetting.tabBarCircleSize
        innerCircleView.layer.cornerRadius = TabBarSetting.tabBarCircleSize.width / 2
        
        outerCircleView.layer.cornerRadius = (innerCircleView.frame.size.height - 10) / 2
        
        stackView.frame = self.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                
        var constraints = [
            outerCircleView.centerYAnchor.constraint(equalTo: self.innerCircleView.centerYAnchor),
            outerCircleView.centerXAnchor.constraint(equalTo: self.innerCircleView.centerXAnchor),
            outerCircleView.heightAnchor.constraint(equalToConstant: innerCircleView.frame.size.height - 10),
            outerCircleView.widthAnchor.constraint(equalToConstant: innerCircleView.frame.size.width - 10),
            tabSelectedImageView.centerYAnchor.constraint(equalTo: outerCircleView.centerYAnchor),
            tabSelectedImageView.centerXAnchor.constraint(equalTo: outerCircleView.centerXAnchor),
            tabSelectedImageView.heightAnchor.constraint(equalToConstant: TabBarSetting.tabBarSizeSelectedImage),
            tabSelectedImageView.widthAnchor.constraint(equalToConstant: TabBarSetting.tabBarSizeSelectedImage),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ]
        if #available(iOS 11.0, *) {
            constraints.append(stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor))
        } else {
            constraints.append(stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchArea = touches.first?.location(in: self).x else {
            return
        }
        let index = Int(floor(touchArea / tabWidth))
        didSelectTab(index: index)
    }
    
    private func didSelectTab(index: Int) {
        if index + 1 == selectedIndex {return}
        animateTitle(index: index)
 
        previousSelectedIndex = selectedIndex
        selectedIndex  = index + 1
        
        delegate?.tabBar(self, didSelectTabAt: index)
        animateCircle(with: circlePath)
        animateImage()
        
        guard let image = self.viewControllers[index].tabBarItem.selectedImage else {
            fatalError("You should insert selected image to all View Controllers")
        }
        self.tabSelectedImageView.image = image
    }
    
    private func animateTitle(index: Int) {
        self.stackView.arrangedSubviews.enumerated().forEach {
            guard let tabView = $1 as? TabBarItem else { return }
            ($0 == index ? tabView.animateTabSelected : tabView.animateTabDeSelect)()
        }
    }
    
    private func animateImage() {
        tabSelectedImageView.alpha = 0
        UIView.animate(withDuration: TabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.tabSelectedImageView.alpha = 1
        }
    }
    
    private func animateCircle(with path: CGPath) {
        let caframeAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        caframeAnimation.path = path
        caframeAnimation.duration = TabBarSetting.tabBarAnimationDurationTime
        caframeAnimation.fillMode = .both
        caframeAnimation.isRemovedOnCompletion = false
        innerCircleView.layer.add(caframeAnimation, forKey: "circleLayerAnimationKey")
    }
}

private extension TabBar {

    var tabWidth: CGFloat {
        return UIScreen.main.bounds.width / CGFloat(viewControllers.count)
    }

    var circlePath: CGPath {
        let startPoint_X = CGFloat(previousSelectedIndex) * CGFloat(tabWidth) - (tabWidth * 0.5)
        let endPoint_X = CGFloat(selectedIndex ) * CGFloat(tabWidth) - (tabWidth * 0.5)
        let y = TabBarSetting.tabBarHeight * 0.1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startPoint_X, y: y))
        path.addLine(to: CGPoint(x: endPoint_X, y: y))
        return path.cgPath
    }
    
}

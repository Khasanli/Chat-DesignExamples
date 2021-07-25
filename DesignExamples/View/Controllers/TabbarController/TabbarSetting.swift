//
//  TabbarSetting.swift
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
//

import Foundation
import UIKit


// Here you can customize the tab bar to meet your neededs
public struct TabBarSetting {
    
    public static var tabBarHeight: CGFloat = 66
    public static var tabBarTintColor: UIColor = UIColor(red: 250/255, green: 51/255, blue: 24/255, alpha: 1)
    public static var tabBarBackground: UIColor = UIColor.white
    public static var tabBarCircleSize = CGSize(width: 65, height: 65)
    public static var tabBarSizeImage: CGFloat = 25
    public static var tabBarShadowColor = UIColor.lightGray.cgColor
    public static var tabBarSizeSelectedImage: CGFloat = 20
    public static var tabBarAnimationDurationTime: Double = 0.4
    
}

//
//  BarViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 11.07.21.
//

import UIKit
import Charts

class BarChartViewController: UIViewController, ChartViewDelegate {
    var barChart : BarChartView = {
        var barchart = BarChartView()
        barchart.translatesAutoresizingMaskIntoConstraints = false
        return barchart
    }()
    
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Bar"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var closeButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(didCloseButtonTouch), for: .touchUpInside)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(titleText)
        view.addSubview(barChart)
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        setSubviews()
        setBarChart()

    }
    private func setSubviews(){
        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/16).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.height/32).isActive = true
        titleText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        titleText.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        titleText.font = UIFont(name: "Arial-BoldMT", size: view.height/30)
        
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.width/16).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/40).isActive = true
        closeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/40).isActive = true
        closeButton.layer.cornerRadius = view.height/40
        
        barChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        barChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        barChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
    }
    @objc func didCloseButtonTouch () {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func setBarChart(){
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data  = BarChartData(dataSet: set)
        barChart.data = data
    }

   

}

//
//  LineChartViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 11.07.21.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {
    var lineChart : LineChartView = {
        var linechart = LineChartView()
        linechart.translatesAutoresizingMaskIntoConstraints = false
        return linechart
    }()
    
    let titleText : UILabel = {
        let label = UILabel()
        label.text = "Line"
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
        view.addSubview(lineChart)
        lineChart.delegate = self
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        setSubviews()
        setLineChart()
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
        
        lineChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lineChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        lineChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true

    }
    @objc func didCloseButtonTouch () {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func setLineChart(){
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        
        let data  = LineChartData(dataSet: set)
        lineChart.data = data
    }
   

}

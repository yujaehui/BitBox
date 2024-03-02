//
//  CustomChartView.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import UIKit
import DGCharts

class CustomChartView: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView(price: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(price: [Double]) {
        var entry: [ChartDataEntry] = []
        for (index, price) in price.enumerated() {
            if index % 4 == 0 {
                entry.append(ChartDataEntry(x: Double(index), y: price))
            }
        }
        
        let set = LineChartDataSet(entries: entry)
        let gradientColors = [ColorStyle.white.cgColor, ColorStyle.purple.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        set.drawFilledEnabled = true
        set.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        set.fillAlpha = 1
        set.lineWidth = 2
        set.colors = [ColorStyle.purple]
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.highlightLineWidth = 0
        
        data = LineChartData(dataSet: set)
        setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        xAxis.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        legend.enabled = false
        let balloonMarker = CustomBalloonMarker(color: ColorStyle.purple, font: FontStyle.primary, textColor: ColorStyle.white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8))
        marker = balloonMarker
    }
}

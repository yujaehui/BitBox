//
//  CustomCircleMarker.swift
//  BitBox
//
//  Created by Jaehui Yu on 2/29/24.
//

import UIKit
import DGCharts

class CustomCircleMarker: MarkerImage {
    @objc var radius: CGFloat = 6
    
    override func draw(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        let strokeRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        
        context.setFillColor(ColorStyle.purple.cgColor)
        context.fillEllipse(in: circleRect)
        context.setStrokeColor(ColorStyle.white.cgColor)
        context.strokeEllipse(in: strokeRect)
    }
}

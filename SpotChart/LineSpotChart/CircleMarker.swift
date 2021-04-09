//
//  CircleMarker.swift
//  SpotChart
//
//  Created by Amir on 3/17/21.
//

import Foundation
import Charts

public class CircleMarker: MarkerImage {
    
    @objc var color: UIColor
    @objc var radius: CGFloat = 5
    
    @objc public init(color: UIColor) {
        self.color = color
        super.init()
    }
    
    public override func draw(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: circleRect)
    }
}

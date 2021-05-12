//
//  LegendModel.swift
//  SpotChart
//
//  Created by Amir on 3/16/21.
//

import Foundation
import UIKit

public struct LegendModel {
    public var key: String!
    public var color: UIColor!
    public var isEnable: Bool!
    public var legendShape: LengendStatusShapeEnum!
    
    public init(key: String,
                color: UIColor,
                isEnable: Bool = true,
                legendShape: LengendStatusShapeEnum = .circle){
        self.key = key
        self.color = color
        self.isEnable = isEnable
        self.legendShape = legendShape
    }
}

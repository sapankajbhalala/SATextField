//
//  Struct+Enums.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 05/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import Foundation
import UIKit

enum SATextfieldType: Int {
  case simple = 0
  case underLine = 1
  case dashedLine = 2
  case border = 3
  case borderWithCornerRadius = 4
  case password = 5
  case floaty = 6
  case dropdown = 7
  case infoView = 8
}

enum dropDownAnimation: Int {
  case up = 0
  case down = 1
}

public struct SATextFieldContentStatus: OptionSet {
  public let rawValue: UInt
  public static let filled = SATextFieldContentStatus(rawValue: 1 << 0)
  public static let empty = SATextFieldContentStatus(rawValue: 1 << 1)
  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
}


// CALayer Extentions
extension CALayer {
  
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    
    let border = CALayer()
    
    switch edge {
    case .top:
      border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
    case .bottom:
      border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
    case .left:
      border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
    case .right:
      border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
    default:
      break
    }
    border.backgroundColor = color.cgColor;
    
    addSublayer(border)
  }
}

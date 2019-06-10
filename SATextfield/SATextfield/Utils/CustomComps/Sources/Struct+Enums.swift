//
//  Struct+Enums.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 05/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import Foundation
import UIKit

//SATextfield type Enums
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

// DropdownAnimation Enums
enum dropDownAnimation: Int {
  case up = 0
  case down = 1
}

// Floaty Textfield content status
public struct FloatyTextFieldContentStatus: OptionSet {
  public let rawValue: UInt
  public static let filled = FloatyTextFieldContentStatus(rawValue: 1 << 0)
  public static let empty = FloatyTextFieldContentStatus(rawValue: 1 << 1)
  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
}

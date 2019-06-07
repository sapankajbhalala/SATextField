//
//  SATextfieldDelegate.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 06/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

public protocol SATextFieldDelegate: UITextFieldDelegate {
  /// validate textfield and set status
  func textFieldValidate(underLineTextField: SATextfield) throws
  /// called when textfield value changed
  func textFieldTextChanged(underLineTextField: SATextfield)
}

public extension SATextFieldDelegate {
  func textFieldValidate(underLineTextField: SATextfield) throws { }
  func textFieldTextChanged(underLineTextField: SATextfield) { }
}

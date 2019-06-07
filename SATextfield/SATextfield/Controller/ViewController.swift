//
//  ViewController.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 05/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var txtNormal: UITextField!
  @IBOutlet weak var txtSA: SATextfield!
  @IBOutlet weak var txtSAUnderLine: SATextfield!
  @IBOutlet weak var txtSADashLine: SATextfield!
  @IBOutlet weak var txtSABorder: SATextfield!
  @IBOutlet weak var txtSABorderWithCornerRadius: SATextfield!
  @IBOutlet weak var txtSAPassword: SATextfield!
  @IBOutlet weak var txtSAFloty: SATextfield!
  @IBOutlet weak var txtSADropDownUpDire: SATextfield!
  @IBOutlet weak var txtSADropDownDownDire: SATextfield!
  @IBOutlet weak var txtSAInfoView: SATextfield!
  
  @IBOutlet weak var conScrollviewBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
    
    txtSADropDownUpDire.dropDownOptions = ["One","Two","Three","Four","Five"]
    txtSADropDownUpDire.type = .dropdown
    txtSADropDownUpDire.dropDownBackgroundColor = UIColor.lightGray
    txtSADropDownUpDire.placeholder = "Select"
    
    txtSADropDownDownDire.dropDownOptions = ["1","2","3","4","5"]
    txtSADropDownDownDire.type = .dropdown
    txtSADropDownDownDire.dropDownBackgroundColor = UIColor.lightGray
    txtSADropDownDownDire.placeholder = "Select"
    
    txtSA.borderStyle = .line
    
    txtSAUnderLine.lineWidth = 2
    txtSAUnderLine.lineColor = UIColor.darkGray
    txtSAUnderLine.type = .underLine
    txtSAUnderLine.placeholder = "Underline"
    
    txtSADashLine.lineWidth = 2
    txtSADashLine.lineColor = UIColor.darkGray
    txtSADashLine.type = .dashedLine
    
    txtSABorder.borderWidth = 2
    txtSABorder.borderColor = UIColor.darkGray
    txtSABorder.type = .border
    
    txtSABorderWithCornerRadius.borderWidth = 2
    txtSABorderWithCornerRadius.borderColor = UIColor.darkGray
    txtSABorderWithCornerRadius.cornerRadius = 5
    txtSABorderWithCornerRadius.type = .borderWithCornerRadius
    
    txtSAPassword.type = .password
    
    txtSAFloty.type = .floaty
    
    txtSAInfoView.infoViewText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    txtSAInfoView.infoViewBackColor = .darkGray
    txtSAInfoView.type = .infoView

  }

  @objc func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let endFrameY = endFrame!.origin.y
      let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
      let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
      if endFrameY >= UIScreen.main.bounds.size.height {
        self.conScrollviewBottom?.constant = 0.0
      } else {
        self.conScrollviewBottom?.constant = endFrame?.size.height ?? 0.0
      }
      UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }


}


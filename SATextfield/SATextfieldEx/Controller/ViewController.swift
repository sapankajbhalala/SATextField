//
//  ViewController.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 05/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import SATextfield

class ViewController: UIViewController, SATextfieldDelegate {

  @IBOutlet weak var txtNormal: UITextField!
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
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
    
    /*
     SATextfield Underline with custom color
     */
    txtSAUnderLine.type = .underLine
    txtSAUnderLine.lineWidth = 2
    txtSAUnderLine.lineColor = UIColor.darkGray
    txtSAUnderLine.placeholder = "Underline"
    
    /*
     SATextfield Dashline with custom color
     */
    txtSADashLine.type = .dashedLine
    txtSADashLine.lineWidth = 2
    txtSADashLine.lineColor = UIColor.darkGray
    
    
    /*
     SATextfield Dropdown upside direction textfield
     */
    txtSADropDownUpDire.type = .dropdown
    txtSADropDownUpDire.dropDownOptions = ["One","Two","Three","Four","Five"]
    txtSADropDownUpDire.dropDownBackgroundColor = UIColor.lightGray
    txtSADropDownUpDire.placeholder = "Select"
    txtSADropDownUpDire.textFieldDelegate = self
    txtSADropDownUpDire.isAutoDetectDirectionDropDown = true
    
    /*
     SATextfield Dropdown downside direction textfield
     */
    txtSADropDownDownDire.type = .dropdown
    txtSADropDownDownDire.dropDownOptions = ["1","2","3","4","5"]
    txtSADropDownDownDire.dropDownBackgroundColor = UIColor.lightGray
    txtSADropDownDownDire.placeholder = "Select"
    txtSADropDownDownDire.textFieldDelegate = self
    
    /*
     SATextfield Border with custom color
     */
    txtSABorder.type = .border
    txtSABorder.borderWidth = 2
    txtSABorder.borderColor = UIColor.darkGray
    
    /*
     SATextfield Border with custom color, corner radius
     */
    txtSABorderWithCornerRadius.type = .borderWithCornerRadius
    txtSABorderWithCornerRadius.borderWidth = 2
    txtSABorderWithCornerRadius.borderColor = UIColor.darkGray
    txtSABorderWithCornerRadius.cornerRadius = 5
    
    /*
     SATextfield password
     */
    txtSAPassword.type = .password
    
    /*
     SATextfield floaty
     */
    txtSAFloty.type = .floaty
    
    /*
     SATextfield InfoView
     */
    txtSAInfoView.infoViewText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    txtSAInfoView.infoViewBackColor = .darkGray
    txtSAInfoView.type = .infoView
    txtSAInfoView.isAutoDetectDirectionInfoview = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  
  // MARK: - SAtextField Delegate
  func dropDown(_ textfield: SATextfield, didSelectItem title: String) {
    if textfield == txtSADropDownUpDire {
      print("UpDire:",title)
    } else if textfield == txtSADropDownDownDire {
      print("DownDire:",title)
    }
  }
  
  // MARK: - UDF
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


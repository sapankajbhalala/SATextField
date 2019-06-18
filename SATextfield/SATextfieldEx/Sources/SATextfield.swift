//
//  SATextfield.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 05/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

@IBDesignable
public class SATextfield: UITextField {
  
  // ==============
  // MARK: - inits
  // ==============
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override open func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  /*
   setup for SATextfield types:
   Floaty, DropDown, InfoView
   */
  private func setup() {
    borderStyle = .none
    self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    if type == .floaty {
      borderStyle = .none
      setupUIFloaty()
    } else if type == .dropdown {
      setupUIDropDown()
    } else if type == .infoView {
      borderStyle = .roundedRect
      setupUIInfoview()
    }
  }
  
  private func setupUIFloaty() {
    floatyNeededConstraint.append(floatyHeightConstraint)
    floatyPlaceholderLabel.text = placeholder
    placeholder = nil
    addTarget(self, action: #selector(self.formTextFieldDidBeginEditing), for: .editingDidBegin)
    addTarget(self, action: #selector(self.formTextFieldDidEndEditing), for: .editingDidEnd)
    addTarget(self, action: #selector(self.formTextFieldValueChanged), for: [.editingChanged, .valueChanged])
    NSLayoutConstraint.activate(floatyNeededConstraint)
    floatyAdjustHeight()
  }
  
  private func setupUIDropDown() {
    dropView.dropDownOptions = dropDownOptions
    dropView.delegate = self
    dropView.translatesAutoresizingMaskIntoConstraints = false
    self.superview?.addSubview(dropView)
    self.superview?.bringSubviewToFront(dropView)
    dropdownBtn = UIButton(type: .custom)
    dropdownBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30  )
    dropdownBtn.addTarget(self, action: #selector(btnDropDownTapped(sender:)), for: .touchUpInside)
    setupAutoDetectDirectionDropdown()
    dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    height = dropView.heightAnchor.constraint(equalToConstant: 0)
    rightView = dropdownBtn
    rightViewMode = .always
  }
  
  fileprivate func setupAutoDetectDirectionDropdown() {
    if type != .dropdown { return }
    dropDownStartCons.isActive = false
    if isAutoDetectDirectionDropDown {
      if (frame.origin.y + frame.size.height + 150) > UIScreen.main.bounds.size.height {
        dropDownStartCons = dropView.bottomAnchor.constraint(equalTo: self.topAnchor)
      } else {
        dropDownStartCons = dropView.topAnchor.constraint(equalTo: self.bottomAnchor)
      }
      if (frame.origin.y + frame.size.height + 150) > UIScreen.main.bounds.size.height {
        if let img = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "up_arrrow")) {
          dropdownBtn.setImage(img, for: .normal)
        }
      } else {
        if let img = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "down_arrow")) {
          dropdownBtn.setImage(img, for: .normal)
        }
      }
    } else {
      dropDownStartCons = dropView.topAnchor.constraint(equalTo: self.bottomAnchor)
      if let img = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "down_arrow")) {
        dropdownBtn.setImage(img, for: .normal)
      }
    }
    dropDownStartCons.isActive = true
  }
  
  private func setupUIInfoview() {
    infoLabelView.lblDesc.text = infoViewText
    infoLabelView.backgroundColor = infoViewBackColor
    infoLabelView.translatesAutoresizingMaskIntoConstraints = false
    self.superview?.addSubview(infoLabelView)
    self.superview?.bringSubviewToFront(infoLabelView)
    setupAutoDetectDirectionInfoview()
    infoLabelView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    infoLabelView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    infoLabelView.isHidden = true
    infoLabelView.alpha = 0
  }
  
  fileprivate func setupAutoDetectDirectionInfoview() {
    if type != .infoView { return }
    infoViewStartCons.isActive = false
    infoViewArrowStartCons.isActive = false
    if isAutoDetectDirectionInfoview {
      if (frame.origin.y + frame.size.height + 150) > UIScreen.main.bounds.size.height {
        infoViewStartCons = infoLabelView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -3)
        infoLabelView.vwArrow.isUp = false
        infoViewArrowStartCons = infoLabelView.vwArrow.topAnchor.constraint(equalTo: infoLabelView.bottomAnchor, constant: 0)
      } else {
        infoViewStartCons = infoLabelView.topAnchor.constraint(equalTo: self.bottomAnchor)
        infoLabelView.vwArrow.isUp = true
        infoViewArrowStartCons = infoLabelView.vwArrow.bottomAnchor.constraint(equalTo: infoLabelView.topAnchor, constant: 0)
      }
    } else {
      infoViewStartCons = infoLabelView.topAnchor.constraint(equalTo: self.bottomAnchor)
      infoLabelView.vwArrow.isUp = true
      infoViewArrowStartCons = infoLabelView.vwArrow.bottomAnchor.constraint(equalTo: infoLabelView.topAnchor, constant: 0)
    }
    infoViewStartCons.isActive = true
    infoViewArrowStartCons.isActive = true
  }

  // ===================
  // MARK: - Variables
  // ===================
  public var type: SATextfieldType = .simple {
    didSet {
      setup()
    }
  }
  
  public weak var textFieldDelegate: SATextfieldDelegate?
  
  private var floatyLineHeight: CGFloat { return font?.pointSize ?? 0 }/// editing text height
  private var floatyPlaceholderHeight: CGFloat { return floatyPlaceholderFont?.pointSize ?? floatyLineHeight }/// placeholder text height
  private var isLayoutCalled = false
  open var animationDuration: Double = 0.3/// animation duration
  
  /// constraints that will be activated upon initilization
  private var floatyNeededConstraint = [NSLayoutConstraint]()
  private lazy var floatyHeightConstraint: NSLayoutConstraint = {
    return NSLayoutConstraint(item: self,
                              attribute: .height,
                              relatedBy: .equal,
                              toItem: nil,
                              attribute: .notAnAttribute,
                              multiplier: 1,
                              constant: 0)
  }()

  
  /* dropDownOptions : Use in
   Types: dropdown */
  public var dropDownOptions: [String] = [String]() {
    didSet {
      dropView.dropDownOptions = dropDownOptions
    }
  }
  private lazy var dropView = DropDownView()
  private var height = NSLayoutConstraint()
  private var dropDownStartCons = NSLayoutConstraint()
  private var infoViewStartCons = NSLayoutConstraint()
  private var infoViewArrowStartCons = NSLayoutConstraint()
  /* dropDownBackgroundColor : Use in
   Types: dropdown */
  public var dropDownBackgroundColor: UIColor = .white {
    didSet {
      dropView.backgroundColor = dropDownBackgroundColor
    }
  }
  /* isAutoDetectDirectionDropDown : Use in
   Types: dropdown */
  public var isAutoDetectDirectionDropDown: Bool = false {
    didSet {
      if oldValue != isAutoDetectDirectionDropDown {
        if isAutoDetectDirectionDropDown {
          setupAutoDetectDirectionDropdown()
        }
      }
    }
  }
  /* isAutoDetectDirectionInfoview : Use in
   Types: infoview */
  public var isAutoDetectDirectionInfoview: Bool = false {
    didSet {
      if oldValue != isAutoDetectDirectionInfoview {
        if isAutoDetectDirectionInfoview {
          setupAutoDetectDirectionInfoview()
        }
      }
    }
  }
  
  
  private var isOpen = false // Check dropdown show/hide
  private lazy var dropdownBtn: UIButton = UIButton()
  //For DropDownTextfield
  
  
  private lazy var underLineLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineCap = CAShapeLayerLineCap.round
    shapeLayer.strokeColor = lineColor.cgColor
    shapeLayer.lineWidth = lineWidth
    let path = CGMutablePath()
    path.addLines(between: [CGPoint(x: 0, y: self.bounds.maxY - lineWidth),CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)])
    shapeLayer.path = path
    return shapeLayer
  }()
  
  private lazy var dashLineLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = lineColor.cgColor
    shapeLayer.lineWidth = lineWidth
    shapeLayer.lineDashPattern = [lineWidth,lineWidth] as [NSNumber]
    let path = CGMutablePath()
    path.addLines(between: [CGPoint(x: 0, y: self.bounds.maxY - lineWidth),CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)])
    shapeLayer.path = path
    return shapeLayer
  }()
  
  /// default is textfield's font
  open var floatyPlaceholderFont: UIFont? {
    didSet {
      floatyPlaceholderLabel.font = floatyPlaceholderFont ?? font
      floatyAdjustHeight()
    }
  }
  /// current content status of textfield (can be empty, filled)
  private var floatyContentStatus: FloatyTextFieldContentStatus = .empty {
    didSet {
      guard floatyContentStatus != oldValue else {
        return
      }
      layoutIfNeeded()
      if floatyContentStatus == .empty {
        setPlaceholderPlace(isUp: false, isAnimated: true)
      } else {
        setPlaceholderPlace(isUp: true, isAnimated: true)
      }
      setNeedsDisplay()
    }
  }
  
  /// label for displaying placeholder
  private lazy var floatyPlaceholderLabel: AnimatableLabel = {
    let label = AnimatableLabel()
    label.font = floatyPlaceholderFont ?? self.font
    label.translatesAutoresizingMaskIntoConstraints = false
    label.animationDuration = animationDuration
    addSubview(label)
    floatyNeededConstraint.append(NSLayoutConstraint(item: label,
                                               attribute: .leading,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .leading,
                                               multiplier: 1,
                                               constant: 0))
    floatyNeededConstraint.append(NSLayoutConstraint(item: label,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0))
    return label
  }()
  
  //Password view
  private var passwordView: UIButton = UIButton()

  //InfoView Textfield
  private lazy var infoLabelView = InfoView()
  /* infoViewText : Use in
   Types: infoView */
  open var infoViewText: String = "" {
    didSet {
      infoLabelView.lblDesc.text = infoViewText
    }
  }
  /* infoViewBackColor : Use in
   Types: infoView */
  open var infoViewBackColor: UIColor = UIColor.lightGray {
    didSet {
      infoLabelView.backgroundColor = infoViewBackColor
    }
  }
  /* infoViewTextColor : Use in
   Types: infoView */
  open var infoViewTextColor: UIColor = UIColor.lightGray {
    didSet {
      infoLabelView.lblDesc.textColor = infoViewTextColor
    }
  }
  private var infoView: UIButton {
    let btn = UIButton(type: .infoLight)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn.addTarget(self, action: #selector(btnInfoViewTapped(sender:)), for: .touchUpInside)
    return btn
  }

  //===================
  // MARK: IBInspectable
  //===================
  /* lineWidth : Use in
   Types: underLine, dashedLine */
  @IBInspectable open var lineWidth: CGFloat = 1 {
    didSet {
      if oldValue != lineWidth {
//        underLineLayer.lineWidth = lineWidth
//        dashLineLayer.lineWidth = lineWidth
        setNeedsDisplay()
      }
    }
  }
  /* lineColor : Use in
   Types: underLine, dashedLine */
  @IBInspectable open var lineColor: UIColor = .lightGray {
    didSet {
      if oldValue != lineColor {
//        underLineLayer.strokeColor = lineColor.cgColor
//        dashLineLayer.strokeColor = lineColor.cgColor
        setNeedsDisplay()
      }
    }
  }
  /* borderWidth : Use in
   Types: border, borderWithCornerRadius */
  @IBInspectable open var borderWidth: CGFloat = 1 {
    didSet {
      if oldValue != borderWidth {
        self.layer.borderWidth = borderWidth
        setNeedsDisplay()
      }
    }
  }
  /* borderColor : Use in
   Types: border, borderWithCornerRadius */
  @IBInspectable open var borderColor: UIColor = .gray {
    didSet {
      if oldValue != borderColor {
        self.layer.borderColor = borderColor.cgColor
        setNeedsDisplay()
      }
    }
  }
  /* borderColor : Use in
   Types: borderWithCornerRadius */
  @IBInspectable open var cornerRadius: CGFloat = 0 {
    didSet {
      if oldValue != cornerRadius {
        self.layer.cornerRadius = cornerRadius
        setNeedsDisplay()
      }
    }
  }
  
  //=================
  // MARK: - Overrides Functions
  //=================
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    if type == .underLine || type == .password || type == .floaty || type == .dropdown {
      if underLineLayer.superlayer == nil {
        layer.addSublayer(underLineLayer)
      }
    }
    if type == .dashedLine {
      if dashLineLayer.superlayer == nil {
        layer.addSublayer(dashLineLayer)
      }
    } else if type == .border {
      setBorder(isRadius: false)
    } else if type == .borderWithCornerRadius {
      setBorder(isRadius: true)
    } else if type == .password {
      self.isSecureTextEntry = true
      setupUIPassword()
      rightView = passwordView
      rightViewMode = .always
    } else if type == .floaty {
      floatyPlaceholderLabel.textColor = lineColor
    } else if type == .dropdown {
      dropView.backgroundColor = dropDownBackgroundColor
    } else if type == .infoView {
      rightView = infoView
      rightViewMode = .always
    }
  }
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: floatyPlaceholderHeight - floatyLineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: floatyPlaceholderHeight - floatyLineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: floatyPlaceholderHeight - floatyLineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    isLayoutCalled = true
  }

}

extension SATextfield {
  
  //================
  // MARK: - UDF
  //================
  private func setupUIPassword() {
    passwordView = UIButton(type: .custom)
    passwordView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    if isSecureTextEntry {
      if let img = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "pass_show")) {
        passwordView.setImage(img, for: .normal)
      }
    } else {
      if let img = UIImage.fromWrappedBundleImage(#imageLiteral(resourceName: "pass_hide")) {
        passwordView.setImage(img, for: .normal)
      }
    }
    passwordView.addTarget(self, action: #selector(btnPasswordTapped(sender:)), for: .touchUpInside)
  }
  /// textfield border
  private func setBorder(isRadius: Bool) {
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    if isRadius {
      self.layer.cornerRadius = cornerRadius
    }
  }
  /// adjust height constraint of control base on font size
  private func floatyAdjustHeight() {
    let lineHeight = textHeightForFont(font: font) + 8
    let placeholderHeight = textHeightForFont(font: floatyPlaceholderFont)
    let height =  lineHeight + placeholderHeight * 0.8
    floatyHeightConstraint.constant = height + 10
    guard isLayoutCalled else { return }
    layoutIfNeeded()
  }
  
  private func heightForView(text:String, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0,y:  0,width:  width,height:  CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
  }
  
  private func textHeightForFont(font: UIFont?) -> CGFloat {
    let font = font ?? self.font ?? .systemFont(ofSize: 17)
    let newText: NSString = NSString(string: "text")
    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    let boundingRect = newText.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
    return boundingRect.size.height
  }
  
  
  private func decideContentStatus(fromText text: String?) {
    if (text ?? "").isEmpty {
      floatyContentStatus = .empty
    } else {
      floatyContentStatus = .filled
    }
  }
  /// change placeholder Place
  private func setPlaceholderPlace(isUp: Bool, isAnimated: Bool) {
    if isUp {
      let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      let dummy = UIView()
      dummy.frame = floatyPlaceholderLabel.frame
      dummy.transform = scaleTransform
      let translateTranform = CGAffineTransform(translationX: floatyPlaceholderLabel.frame.origin.x - dummy.frame.origin.x,
                                                y: -dummy.frame.origin.y)
      guard isAnimated else {
        floatyPlaceholderLabel.textColor = lineColor
        floatyPlaceholderLabel.transform = scaleTransform.concatenating(translateTranform)
        return
      }
      UIView.animate(withDuration: animationDuration, animations: {
        self.floatyPlaceholderLabel.transform = scaleTransform.concatenating(translateTranform)
      })
    } else {
      guard isAnimated else {
        floatyPlaceholderLabel.textColor = lineColor
        self.floatyPlaceholderLabel.transform = .identity
        return
      }
      UIView.animate(withDuration: animationDuration, animations: {
        self.floatyPlaceholderLabel.transform = .identity
      })
    }
  }
  
  private func showDropDown() {
    resignFirstResponder()
    NSLayoutConstraint.deactivate([height])
    if dropView.tableView.contentSize.height > 150 {
      height.constant = 150
    } else {
      height.constant = dropView.tableView.contentSize.height
    }
    NSLayoutConstraint.activate([height])
    
    UIView.animate(withDuration: animationDuration, animations: {
      self.dropView.layoutIfNeeded()
      if self.isAutoDetectDirectionDropDown {
        if (self.frame.origin.y + self.frame.size.height + 150) > UIScreen.main.bounds.size.height {
          self.dropView.center.y -= self.dropView.frame.height / 2
        } else {
          self.dropView.center.y += self.dropView.frame.height / 2
        }
      } else {
        self.dropView.center.y += self.dropView.frame.height / 2
      }
    }, completion: nil)
  }
  private func hideDropDown() {
    NSLayoutConstraint.deactivate([height])
    height.constant = 0
    NSLayoutConstraint.activate([height])
    UIView.animate(withDuration: animationDuration, animations: {
      if self.isAutoDetectDirectionDropDown {
        if (self.frame.origin.y + self.frame.size.height + 150) > UIScreen.main.bounds.size.height {
          self.dropView.center.y += self.dropView.frame.height / 2
        } else {
          self.dropView.center.y -= self.dropView.frame.height / 2
        }
      } else {
        self.dropView.center.y -= self.dropView.frame.height / 2
      }
      self.dropView.layoutIfNeeded()
    }, completion: nil)
  }
  
}


// ===================
// MARK: - Override Variables
// ===================
extension SATextfield {
  override open var font: UIFont? {
    set {
      super.font = newValue
      floatyPlaceholderLabel.font = newValue
      floatyAdjustHeight()
    }
    get {
      return super.font
    }
  }
}

@objc
extension SATextfield {
  /// textfield become first responder
  private func formTextFieldDidBeginEditing() {
    layoutIfNeeded()
  }
  /// textfield resigned first responder
  private func formTextFieldDidEndEditing() {
    layoutIfNeeded()
  }
  /// textfield value changed
  private func formTextFieldValueChanged() {
    (delegate as? FloatyTextFieldDelegate)?
      .textFieldTextChanged(underLineTextField: self)
    decideContentStatus(fromText: text)
  }
  
  //show hide password on password textfield
  private func btnPasswordTapped(sender: UIButton) {
    isSecureTextEntry = !isSecureTextEntry
    setupUIPassword()
    rightView = passwordView
  }
  private func btnInfoViewTapped(sender: UIButton) {
    if self.infoLabelView.isHidden {
      UIView.animate(withDuration: 0.5, animations: {
        self.infoLabelView.isHidden = false
        self.infoLabelView.alpha = 1
      }, completion: nil)
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.infoLabelView.alpha = 0
      }) { (status) in
        self.infoLabelView.isHidden = true
      }
    }
    
  }
  @objc private func btnDropDownTapped(sender: UIButton) {
    if isOpen {
      isOpen = false
      hideDropDown()
    } else {
      isOpen = true
      showDropDown()
    }
  }
}

//DropDown Protocol
extension SATextfield: dropDownProtocol {
  func dropDownPressed(string: String) {
    text = string
    isOpen = false
    hideDropDown()
    textFieldDelegate?.dropDown(self, didSelectItem: string)
  }
}

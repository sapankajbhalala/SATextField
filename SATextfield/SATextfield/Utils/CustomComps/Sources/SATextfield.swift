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
  
  // MARK: - Init
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
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  // MARK: - Variables
  var type: SATextfieldType = .simple {
    didSet {
      setup()
    }
  }
  /// editing text height
  private var lineHeight: CGFloat {
    return font?.pointSize ?? 0
  }
  
  /// placeholder text height
  private var placeholderHeight: CGFloat {
    return placeholderFont?.pointSize ?? lineHeight
  }

  private var isLayoutCalled = false
  /// animation duration for changing states
  open var animationDuration: Double = 0.3
  
  /// constraints that will be activated upon initilization
  private var neededConstraint = [NSLayoutConstraint]()
  private lazy var heightConstraint: NSLayoutConstraint = {
    return NSLayoutConstraint(item: self,
                              attribute: .height,
                              relatedBy: .equal,
                              toItem: nil,
                              attribute: .notAnAttribute,
                              multiplier: 1,
                              constant: 0)
  }()

  
  //For DropDownTextfield
  var dropDownOptions: [String] = [String]()
  private lazy var dropView = DropDownView()
  private var height = NSLayoutConstraint()
  var dropDownBackgroundColor: UIColor = .white
  private var isOpen = false // Check dropdown show/hide
  private lazy var dropdownBtn: UIButton = {
    let btn = UIButton(type: .custom)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30  )
    btn.addTarget(self, action: #selector(btnDropDownTapped(sender:)), for: .touchUpInside)
    if (frame.origin.y + frame.size.height) > UIScreen.main.bounds.size.height {
      btn.setImage(UIImage(named: "up_arrrow"), for: .normal)
    } else {
      btn.setImage(UIImage(named: "down_arrow"), for: .normal)
    }
    return btn
  }()
  //For DropDownTextfield
  
  open lazy var lineLayer: CAShapeLayer = {
    let layer = CAShapeLayer(layer: self.layer)
    layer.lineCap = CAShapeLayerLineCap.round
    layer.strokeColor = lineColor.cgColor
    layer.lineWidth = lineWidth
    let path = CGMutablePath()
    path.addLines(between: [CGPoint(x: 0, y: self.bounds.maxY - lineWidth),CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)])
    layer.path = path
    return layer
  }()
  
  open lazy var dashLineLayer: CAShapeLayer = {
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
  open var placeholderFont: UIFont? {
    didSet {
      placeholderLabel.font = placeholderFont ?? font
      adjustHeight()
    }
  }
  
  
  /// current content status of textfield (can be empty, filled)
  open var contentStatus: SATextFieldContentStatus = .empty {
    didSet {
      guard contentStatus != oldValue else {
        return
      }
      layoutIfNeeded()
      if contentStatus == .empty {
        setPlaceholderPlace(isUp: false, isAnimated: true)
      } else {
        setPlaceholderPlace(isUp: true, isAnimated: true)
      }
      setNeedsDisplay()
    }
  }
  
  /// label for displaying placeholder
  private lazy var placeholderLabel: AnimatableLabel = {
    let label = AnimatableLabel()
    label.font = placeholderFont ?? self.font
    label.translatesAutoresizingMaskIntoConstraints = false
    label.animationDuration = animationDuration
    addSubview(label)
    neededConstraint.append(NSLayoutConstraint(item: label,
                                               attribute: .leading,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .leading,
                                               multiplier: 1,
                                               constant: 0))
    neededConstraint.append(NSLayoutConstraint(item: label,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0))
    return label
  }()
  
  //Password view
  internal var passwordView: UIButton {
    let btn = UIButton(type: .custom)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    if isSecureTextEntry {
      btn.setImage(UIImage(named: "pass_show"), for: .normal)
    } else {
      btn.setImage(UIImage(named: "pass_hide"), for: .normal)
    }
    btn.addTarget(self, action: #selector(btnPasswordTapped(sender:)), for: .touchUpInside)
    return btn
  }

  //InfoView Textfield
  private lazy var infoLabelView = InfoView()
  var infoViewText: String = ""
  var infoViewBackColor: UIColor = UIColor.lightGray
  private var infoView: UIButton {
    let btn = UIButton(type: .infoLight)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn.addTarget(self, action: #selector(btnInfoViewTapped(sender:)), for: .touchUpInside)
    return btn
  }

  
  @IBInspectable open var lineWidth: CGFloat = 1 {
    didSet {
      if oldValue != lineWidth {
        setNeedsDisplay()
      }
    }
  }
  @IBInspectable open var lineColor: UIColor = .lightGray {
    didSet {
      if oldValue != lineColor {
        setNeedsDisplay()
      }
    }
  }
  
  @IBInspectable open var borderWidth: CGFloat = 1 {
    didSet {
      if oldValue != borderWidth {
        setNeedsDisplay()
      }
    }
  }
  
  @IBInspectable open var borderColor: UIColor = .gray {
    didSet {
      if oldValue != borderColor {
        setNeedsDisplay()
      }
    }
  }
  @IBInspectable open var cornerRadius: CGFloat = 0 {
    didSet {
      if oldValue != cornerRadius {
        setNeedsDisplay()
      }
    }
  }
  
  // MARK: - Functions
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    if type == .underLine || type == .password || type == .floaty || type == .dropdown {
      if lineLayer.superlayer == nil {
        layer.addSublayer(lineLayer)
      }
    }
    if type == .underLine {
    } else if type == .dashedLine {
      if dashLineLayer.superlayer == nil {
        layer.addSublayer(dashLineLayer)
      }
    } else if type == .border {
      setBorder(isRadius: false)
    } else if type == .borderWithCornerRadius {
      setBorder(isRadius: true)
    } else if type == .password {
      self.isSecureTextEntry = true
      rightView = passwordView
      rightViewMode = .always
    } else if type == .floaty {
      placeholderLabel.textColor = lineColor
    } else if type == .dropdown {
      dropView.backgroundColor = dropDownBackgroundColor
    } else if type == .infoView {
      rightView = infoView
      rightViewMode = .always
    }
  }
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: placeholderHeight - lineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: placeholderHeight - lineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(top: placeholderHeight - lineHeight - 7, left: 0, bottom: 0, right: 0)
    return bounds.inset(by: padding)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    isLayoutCalled = true
  }
  
  /// textfield border
  private func setBorder(isRadius: Bool) {
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    if isRadius {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
}

//Floaty Textfield
extension SATextfield {
  
  private func setup() {
    if type == .floaty {
      self.borderStyle = .none
      neededConstraint.append(heightConstraint)
      borderStyle = .none
      tintColor = super.tintColor
      clearButtonMode = super.clearButtonMode
      placeholderLabel.text = placeholder
      placeholder = nil
      addTarget(self, action: #selector(self.formTextFieldDidBeginEditing), for: .editingDidBegin)
      addTarget(self, action: #selector(self.formTextFieldDidEndEditing), for: .editingDidEnd)
      addTarget(self, action: #selector(self.formTextFieldValueChanged), for: [.editingChanged, .valueChanged])
      NSLayoutConstraint.activate(neededConstraint)
      adjustHeight()
      text = super.text
    } else if type == .dropdown {
      dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
      dropView.dropDownOptions = dropDownOptions
      dropView.delegate = self
      dropView.translatesAutoresizingMaskIntoConstraints = false
      self.superview?.addSubview(dropView)
      self.superview?.bringSubviewToFront(dropView)
      if (frame.origin.y + frame.size.height) > UIScreen.main.bounds.size.height {
        dropView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
      } else {
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      }
      dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
      height = dropView.heightAnchor.constraint(equalToConstant: 0)
      
      rightView = dropdownBtn
      rightViewMode = .always
    } else if type == .infoView {
      borderStyle = .roundedRect
      infoLabelView = InfoView(frame: CGRect(x: 0, y: 0, width: frame.size.width - 10, height: heightForView(text: infoViewText, width: frame.size.width - 16)))
      infoLabelView.lblDesc.text = infoViewText
      infoLabelView.backgroundColor = infoViewBackColor
      infoLabelView.translatesAutoresizingMaskIntoConstraints = false
      self.superview?.addSubview(infoLabelView)
      self.superview?.bringSubviewToFront(infoLabelView)
      if (frame.origin.y + frame.size.height) > UIScreen.main.bounds.size.height {
        infoLabelView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -3).isActive = true
        infoLabelView.vwArrow.isUp = false
        infoLabelView.vwArrow.topAnchor.constraint(equalTo: infoLabelView.bottomAnchor, constant: 0).isActive = true
      } else {
        infoLabelView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        infoLabelView.vwArrow.isUp = true
        infoLabelView.vwArrow.bottomAnchor.constraint(equalTo: infoLabelView.topAnchor, constant: 0).isActive = true
      }
      infoLabelView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      infoLabelView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
      infoLabelView.isHidden = true
    }
  }
  
  
  /// adjust height constraint of control base on font size
  private func adjustHeight() {
    let lineHeight = textHeightForFont(font: font) + 8
    let placeholderHeight = textHeightForFont(font: placeholderFont)
    let height =  lineHeight + placeholderHeight * 0.8
    heightConstraint.constant = height + 10
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
      contentStatus = .empty
    } else {
      contentStatus = .filled
    }
  }
  /// change placeholder Place
  private func setPlaceholderPlace(isUp: Bool, isAnimated: Bool) {
    if isUp {
      let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      let dummy = UIView()
      dummy.frame = placeholderLabel.frame
      dummy.transform = scaleTransform
      let translateTranform = CGAffineTransform(translationX: placeholderLabel.frame.origin.x - dummy.frame.origin.x,
                                                y: -dummy.frame.origin.y)
      guard isAnimated else {
        placeholderLabel.textColor = lineColor
        placeholderLabel.transform = scaleTransform.concatenating(translateTranform)
        return
      }
      UIView.animate(withDuration: animationDuration, animations: {
        self.placeholderLabel.transform = scaleTransform.concatenating(translateTranform)
      })
    } else {
      guard isAnimated else {
        placeholderLabel.textColor = lineColor
        self.placeholderLabel.transform = .identity
        return
      }
      UIView.animate(withDuration: animationDuration, animations: {
        self.placeholderLabel.transform = .identity
      })
    }
  }
  
}


//Override variables
extension SATextfield {
  override open var text: String? {
    get {
      return super.text
    }
    set {
      super.text = newValue
      decideContentStatus(fromText: text)
      setNeedsDisplay()
    }
  }
  override open var font: UIFont? {
    set {
      super.font = newValue
      placeholderLabel.font = newValue
      adjustHeight()
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
    (delegate as? SATextFieldDelegate)?
      .textFieldTextChanged(underLineTextField: self)
    decideContentStatus(fromText: text)
  }
  
  //show hide password on password textfield
  private func btnPasswordTapped(sender: UIButton) {
    isSecureTextEntry = !isSecureTextEntry
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
      if (self.frame.origin.y + self.frame.size.height) > UIScreen.main.bounds.size.height {
        self.dropView.center.y -= self.dropView.frame.height / 2
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
      if (self.frame.origin.y + self.frame.size.height) > UIScreen.main.bounds.size.height {
        self.dropView.center.y += self.dropView.frame.height / 2
      } else {
        self.dropView.center.y -= self.dropView.frame.height / 2
      }
      self.dropView.layoutIfNeeded()
    }, completion: nil)
  }
}

//DropDown Protocol
extension SATextfield: dropDownProtocol {
  func dropDownPressed(string: String) {
    text = string
    isOpen = false
    hideDropDown()
  }
  
}

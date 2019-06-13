//
//  AnimatadLabel.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 06/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
open class AnimatableLabel: UIView {
  //============
  // MARK: - inits
  //============
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initial()
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initial()
  }
  private func initial() {
    widthConstraint = widthAnchor.constraint(equalToConstant: 0)
    heightConstraint = heightAnchor.constraint(equalToConstant: 0)
    widthConstraint.priority = .defaultLow
    heightConstraint.priority = .defaultLow
    NSLayoutConstraint.activate([heightConstraint, widthConstraint])
    setContentSize()
  }
  
  //=================
  // MARK: - Variables
  //=================
  private var textFont = UIFont.systemFont(ofSize: 15)
  private var widthConstraint: NSLayoutConstraint!
  private var heightConstraint: NSLayoutConstraint!
  var animationDuration: Double = 0.4
  
  open var font: UIFont! {
    set {
      textFont = newValue
      let fontName = newValue.fontName as NSString
      textLayer.font = CGFont.init(fontName)
      textLayer.fontSize = newValue.pointSize
      setContentSize()
    }
    get {
      return textFont
    }
  }
  
  open var text: String? {
    set {
      textLayer.string = newValue
      setContentSize()
    }
    get {
      return textLayer.string as? String
    }
    
  }
  open var textColor: UIColor! {
    set {
      textLayer.foregroundColor = newValue.cgColor
    }
    get {
      guard let cgColor = textLayer.foregroundColor else {
        return .clear
      }
      return UIColor(cgColor: cgColor)
    }
  }
  
  //=====================
  // MARK: Lazy Loadings
  //=====================
  lazy var textLayer: VerticalAlignedTextLayer = {
    let textLayer = VerticalAlignedTextLayer()
    textLayer.contentsScale = UIScreen.main.scale
    textLayer.truncationMode = CATextLayerTruncationMode.end
    layer.addSublayer(textLayer)
    return textLayer
  }()
}

extension AnimatableLabel {
  //=================
  // MARK: - Overrides
  //=================
  override open var backgroundColor: UIColor? {
    set {
      super.backgroundColor = newValue
      textLayer.backgroundColor = newValue?.cgColor
    }
    get {
      return super.backgroundColor
    }
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    textLayer.frame = self.bounds
  }
  
  override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    return nil
  }
  
  override open func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    initial()
  }
}

extension AnimatableLabel {
  //================
  // MARK: - Methods
  //================
  func setContentSize() {
    let newText: NSString = NSString(string: text ?? "")
    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    let boundingRect = newText.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font!],
                                            context: nil)
    widthConstraint.constant = boundingRect.width + 8
    heightConstraint.constant = boundingRect.height
    layoutIfNeeded()
  }
  
  open func changeText(toColor color: UIColor, animated: Bool = true) {
    guard animated else {
      textColor = color
      return
    }
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationDuration)
    CATransaction
      .setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    textColor = color
    CATransaction.commit()
  }
}


// VerticalAlignedTextLayer
class VerticalAlignedTextLayer: CATextLayer {
  //============
  // MARK: - inits
  //============
  override init() {
    super.init()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(layer: aDecoder)
  }
}

extension VerticalAlignedTextLayer {
  //=================
  // MARK: - Overrides
  //=================
  override func draw(in ctx: CGContext) {
    let height = self.bounds.size.height
    let fontSize = self.fontSize
    let yDiff = (height-fontSize) / 2 - fontSize / 10
    ctx.saveGState()
    ctx.translateBy(x: 0.0, y: yDiff)
    super.draw(in: ctx)
    ctx.restoreGState()
  }
}


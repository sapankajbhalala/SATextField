//
//  InfoView.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 07/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class InfoView: UIView {

  var lblDesc = UILabel()
  var vwArrow = Triangle()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInfoView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupInfoView()
  }
  override var backgroundColor: UIColor?{
    didSet {
      vwArrow.color = backgroundColor!
    }
  }
  func setupInfoView() {
    
    layer.cornerRadius = 5
    
    lblDesc.numberOfLines = 0
    lblDesc.lineBreakMode = .byWordWrapping
    lblDesc.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(lblDesc)
    lblDesc.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    lblDesc.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
    lblDesc.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
    lblDesc.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
    
    vwArrow.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(vwArrow)
    
    vwArrow.heightAnchor.constraint(equalToConstant: 10).isActive = true
    vwArrow.widthAnchor.constraint(equalToConstant: 10).isActive = true
    vwArrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    
  }
}


@IBDesignable
class Triangle: UIView {
  @IBInspectable var color: UIColor = .red
  @IBInspectable var firstPointX: CGFloat = 0
  @IBInspectable var firstPointY: CGFloat = 0
  @IBInspectable var secondPointX: CGFloat = 0.5
  @IBInspectable var secondPointY: CGFloat = 1
  @IBInspectable var thirdPointX: CGFloat = 1
  @IBInspectable var thirdPointY: CGFloat = 0
  var isUp: Bool = false
  override func draw(_ rect: CGRect) {
    let aPath = UIBezierPath()
    if isUp {
      firstPointX = 0.5
      secondPointX = 0
      thirdPointY = 1
    } else {
      
    }
    aPath.move(to: CGPoint(x: self.firstPointX * rect.width, y: self.firstPointY * rect.height))
    aPath.addLine(to: CGPoint(x: self.secondPointX * rect.width, y: self.secondPointY * rect.height))
    aPath.addLine(to: CGPoint(x: self.thirdPointX * rect.width, y: self.thirdPointY * rect.height))
    aPath.close()
    self.color.set()
    self.backgroundColor = .clear
    aPath.fill()
  }
  
}

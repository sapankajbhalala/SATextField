//
//  DropDownView.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 06/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

open class DropDownView: UIView {

  var dropDownOptions: [String] = [String]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  var tableView = UITableView()
  var delegate : dropDownProtocol!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDropDown()
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupDropDown()
  }
  
  func setupDropDown() {
    
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 5
    clipsToBounds = true
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = backgroundColor
    self.addSubview(tableView)
    
    tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
}


protocol dropDownProtocol {
  func dropDownPressed(string : String)
}

// DropDownView Tableview Delegate
extension DropDownView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
  }
}

// DropDownView Tableview Datasource
extension DropDownView: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dropDownOptions.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = dropDownOptions[indexPath.row]
    cell.backgroundColor = backgroundColor
    cell.selectionStyle = .none
    return cell
  }
  
  
}

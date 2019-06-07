//
//  DropDownView.swift
//  SATextfield
//
//  Created by Pankaj Bhalala on 06/06/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class DropDownView: UIView {

  var dropDownOptions = [String]()
  
  var tableView = UITableView()
  var delegate : dropDownProtocol!
  var dropDownBackgroundColor: UIColor = .white
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDropDown()
  }
  required init?(coder aDecoder: NSCoder) {
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
//    backgroundColor = dropDownBackgroundColor
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
  }
}

// DropDownView Tableview Datasource
extension DropDownView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dropDownOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = dropDownOptions[indexPath.row]
    cell.backgroundColor = backgroundColor
    cell.selectionStyle = .none
    return cell
  }
  
  
}

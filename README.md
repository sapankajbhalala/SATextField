# SATextField

This framework is made with intension to have extended functionality to use UITextField. You can have Dropdown, Underline, Floaty textfield, Infoview, PasswordView with textfield. This code provides all in one tool to manage textfield.

# Getting Started
### Quick Layout Design
There are some of types that use to quick layout design:

* .underLine
* .dashedLine
* .border
* .borderWithCornerRadius
* .password
* .floaty
* .dropdown
* .infoView

## Looks Like

```swift
textfield.type = .underline
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_Underline.png)

```swift
textfield.type = .dashedLine
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_DashLine.png)

```swift
textfield.type = .border
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_Border.png)

```swift
textfield.type = .borderWithCornerRadius
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_BorderWithCorner.png)

```swift
textfield.type = .password
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_Password.png)

```swift
textfield.type = .floaty
```
![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_Floaty.png)

```swift
textfield.isAutoDetectDirectionDropDown = true
textfield.type = .dropdown
```
Dropdown auto detect direction (Up side show/ Down side show)

Using ```isAutoDetectDirectionDropDown = true //Default value is false```
dropdown automatically define direction to show and hide.



![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_DropdownDirUp.png)

![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_DropdownDirDown.png)

![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_DropdownDirDownEx.png)


```swift
textfield.isAutoDetectDirectionInfoview = true
textfield.type = .infoView
textfield.infoViewText = "Sample Text"
textfield.infoViewBackColor = .darkGray
```
Using ```isAutoDetectDirectionInfoview = true //Default value is false```
infoview automatically define direction to show and hide.



![alt text](https://github.com/sapankajbhalala/SATextField/blob/master/SATextfield/SATextfieldEx/Resources/Images/SATextfield_InfoView.png)


### Prerequisites

Swift 4.2

iOS 10*

Xcode 10

## Installation

### Using Pod
You want to add pod 'SATextfield' similar to the following to your Podfile
```
target 'MyApp' do

  pod 'SATextfield'
  
end
```

### Using Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:
```
$ brew update
$ brew install carthage
```
To integrate SATextfield into your Xcode project using Carthage, specify it in your Cartfile:

	github "sapankajbhalala/SATextfield" "master"
	
Run "carthage update" to build the framework and drag the built SATextfield.framework into your Xcode project.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate SATextfield into your project manually. Just copy the source folder in your project directory from [Source](https://github.com/sapankajbhalala/SATextField/tree/master/SATextfield/SATextfieldEx/Utils/CustomComps/Sources)

## How to use?
```swift
import SATextfield

class VC1: UIViewController{
  @IBOutlet weak var textfield: SATextfield!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textfield.type = .underline //specify which type you want to use
  }
}
```

Here some customise options like:
```swift
// For .underline and .dashline type:
    textfield.lineWidth = 2
    textfield.lineColor = UIColor.darkGray
    
// For .border type:
    textfield.borderWidth = 2
    textfield.borderColor = UIColor.darkGray

// For .borderWithCornerRadius type:
    textfield.borderWidth = 2
    textfield.borderColor = UIColor.darkGray
    textfield.cornerRadius = 5
    
// For .infoView type:
    textfield.infoViewBackColor = UIColor.darkGray
    textfield.infoViewTextColor = UIColor.black
    textfield.infoViewText = "How to use this framework?"

// For .dropdown type:
    textfield.dropDownBackgroundColor = UIColor.darkGray
    textfield.dropDownOptions = ["One","Two","Three","Four","Five"]
```

### SATextfieldDelegate
Using SATextfieldDelegate get selected value from dropdown.

```swift
class ViewController: UIViewController, SATextfieldDelegate {
......
....
  textfield.textFieldDelegate = self
}
```

Get dropdown selected value using SATextfieldDelegate method:
```swift
// MARK: - SAtextField Delegate
  func dropDown(_ textfield: SATextfield, didSelectItem title: String) {
      print(title)
  }
```

## Authors
Solution Analyst

## License

MIT License

Copyright (c) 2019 Solution Analysts Pvt. Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

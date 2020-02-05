//
//  Utils.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static let sharedInstance: Utils = {
        let instance = Utils()
        return instance
    }()
    
    func dateToString(date:Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: date)
    }
    
    
}
extension UIAlertController{
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
           let action = UIAlertAction(title: title, style: style, handler: handler)
           action.isEnabled = isEnabled
           
           if let image = image {
               action.setValue(image, forKey: "image")
           }
           
           if let color = color {
               action.setValue(color, forKey: "titleTextColor")
           }
           
           addAction(action)
       }
}
extension UISearchBar {
    
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    var containsDigits : Bool {
           return(self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
    }
}

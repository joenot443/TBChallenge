//
//  EditItemTableViewCell.swift
//  
//
//  Created by Joe Crozier on 2019-06-27.
//

import UIKit

class MenuEditTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    var delegate: MenuEditDelegate?
    var editType: EditType! {
        didSet {
            textField.keyboardType = editType.keyboardType()
        }
    }
    var initialValue: String? {
        didSet {
            textField.text = initialValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.text = ""
    }
    
    func validate(text: String) {
        let result = editType.Validator().validate(text: text, type: editType)
        
        if result.success {
            textField.resignFirstResponder()
            // Force unwrap because we know a successful result means a guaranteed value
            delegate?.didFinishEditing(editType: editType, value: result.value!)
        } else if let error = result.error {
            delegate?.didFailEditing(withErrorMessage: error, editType: editType)
        }
    }
    
    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        validate(text: text)
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        validate(text: text)
    }
    
}

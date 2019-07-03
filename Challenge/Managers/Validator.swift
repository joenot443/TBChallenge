//
//  Validator.swift
//  Challenge
//
//  Created by Joe Crozier on 2019-06-27.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit


protocol Validator {
    static func validate(text: String, type: EditType) -> EditResult
}

struct ValidatorConstants {
    static let textTooLongError = "The text you entered is too long by %d characters!"
    static let textTooShortError = "The text you entered is too short by %d characters!"
    static let badFloatError = "The price you entered wasn't a valid format!"
    static let badUrlError = "The URL you entered wasn't valid"
    static let priceTooHighError = "The price you entered was too high, the max is %.2f"
    static let priceTooLowError = "The price you entered was too low, the min is %.2f"
    static let successMessage = "Your change has been saved!"
}

enum EditType {
    case itemNameEdit, groupNameEdit, priceEdit, groupImageUrlEdit, itemImageUrlEdit
    
    func update(object: Any, value: Any) -> MenuOperationResult {
        switch self {
        case .itemNameEdit: return MenuManager.shared.update(item: object as! MenuItem, name: value as! String)
        case .groupNameEdit: return MenuManager.shared.update(group: object as! MenuGroup, name: value as! String)
        case .priceEdit: return MenuManager.shared.update(item: object as! MenuItem, price: value as! Float)
        case .groupImageUrlEdit: return MenuManager.shared.update(group: object as! MenuGroup, imageUrl: value as! URL)
        case .itemImageUrlEdit: return MenuManager.shared.update(item: object as! MenuItem, imageUrl: value as! URL)
        }
    }
    
    func minLength() -> Int{
        switch self {
        case .itemNameEdit, .groupNameEdit: return 5
        default: return 0
        }
    }
    
    func maxLength() -> Int {
        switch self {
        case .itemNameEdit, .groupNameEdit: return 20
        default: return Int.max
        }
    }
    
    func minPrice() -> Float {
        switch self {
        case .priceEdit: return 0.01
        default: return 0.0
        }
    }
    
    func maxPrice() -> Float {
        switch self {
        case .priceEdit: return 99.99
        default: return 0.0
        }
    }
    
    func keyboardType() -> UIKeyboardType {
        switch self {
        case .priceEdit: return UIKeyboardType.decimalPad
        default: return UIKeyboardType.default
        }
    }
    
    func Validator() -> Validator.Type {
        switch self {
        case .itemNameEdit, .groupNameEdit: return TextValidator.self
        case .priceEdit: return PriceValidator.self
        case .groupImageUrlEdit, .itemImageUrlEdit: return ImageUrlValidator.self
        }
    }
}

struct EditResult {
    let success: Bool
    let error: String?
    let value: Any?
}

struct TextValidator: Validator {
    static func validate(text: String, type: EditType) -> EditResult {
        if text.count > type.maxLength() {
            return EditResult(success: false, error: String(format: ValidatorConstants.textTooLongError, text.count - type.maxLength()), value: text)}
        
        if text.count < type.minLength() {
            return EditResult(success: false, error: String(format: ValidatorConstants.textTooShortError, type.minLength() - text.count), value: text)}
        
        return EditResult(success: true, error: nil, value: text)
    }
}

struct PriceValidator: Validator {
    static func validate(text: String, type: EditType) -> EditResult {
        guard let price = Float(text) else {
            return EditResult(success: false, error: ValidatorConstants.badFloatError, value: nil)
        }
        if price > EditType.priceEdit.maxPrice() {
            return EditResult(success: false, error: String(format: ValidatorConstants.priceTooHighError, EditType.priceEdit.maxPrice()), value: price)
            
        }
        if price < EditType.priceEdit.minPrice() {
            return EditResult(success: false, error: String(format: ValidatorConstants.priceTooLowError, EditType.priceEdit.minPrice()), value: price)
        }
        
        return EditResult(success: true, error: nil, value: price)
    }
}

struct ImageUrlValidator: Validator {
    static func validate(text: String, type: EditType) -> EditResult {
        guard let url = URL(string: text) else {
            return EditResult(success: false, error: ValidatorConstants.badUrlError, value: text)
        }
        // Could definitely add some more exhaustive checks to ensure the URL is an actual image
        return EditResult(success: true, error: nil, value: url)
    }
}

//
//  NewItemTableViewController.swift
//  Challenge
//
//  Created by Joseph Crozier on 2019-07-02.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit

class NewItemTableViewController: ItemEditTableViewController {
    var itemName: String?
    var imageUrl: URL?
    var itemPrice: Float?
    
    lazy private var doneBarButtonItem: UIBarButtonItem = { [weak self] in
        return UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonPressed))
        }()
    
    struct NewItemTableViewConstants {
        static let newItemTitleKey = "New Item for %@"
        static let touchBistroLogoImageURL = "https://i.imgur.com/Jfbg8uD.png"
    }
    
    override func updateTitle() {
        navigationItem.title = String(format: NewItemTableViewConstants.newItemTitleKey, group.name ?? "Group")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneBarButtonItem
        updateTitle()
        // Give our imageURL a default value for convenience's sake
        imageUrl = URL(string: NewItemTableViewConstants.touchBistroLogoImageURL)
    }

    override func didFinishEditing(editType: EditType, value: Any) {
        switch editType {
        case .itemNameEdit: itemName = value as? String
        case .itemImageUrlEdit: imageUrl = value as? URL
        case .priceEdit: itemPrice = value as? Float
        default: break
        }
        resignFirstResponder()
        updateDoneButtonEnabled()
    }
    
    override func didFailEditing(withErrorMessage message: String, editType: EditType) {
        view.makeToast(message, duration: 3.0, position: .center)
        switch editType {
        case .itemNameEdit: itemName = nil
        case .itemImageUrlEdit: imageUrl = nil
        case .priceEdit: itemPrice = nil
        default: break
        }
        updateDoneButtonEnabled()
    }
    
    func updateDoneButtonEnabled() {
        doneBarButtonItem.isEnabled = itemName != nil && imageUrl != nil && itemPrice != nil
    }
    
    @objc func doneButtonPressed() {
        let result = MenuManager.shared.addItem(name: itemName!, price: itemPrice!, imageUrl: imageUrl!, group: group)
        if let message = result.error {
            view.makeToast(message, duration: 3.0, position: .center)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}

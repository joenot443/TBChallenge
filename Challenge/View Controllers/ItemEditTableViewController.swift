//
//  ItemEditTableViewController.swift
//  Challenge
//
//  Created by Joe Crozier on 2019-06-27.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import Toast_Swift

protocol MenuEditDelegate {
    func didFailEditing(withErrorMessage message: String, editType: EditType)
    func didFinishEditing(editType: EditType, value: Any)
}

class ItemEditTableViewController: UITableViewController, MenuEditDelegate {
    struct ItemEditTableViewConstants {
        static let itemEditCellReuseIdentifier = "ItemEditCell"
        static let itemEditCellNib = "MenuEditTableViewCell"
        static let touchBistroLogoImageURL = "https://i.imgur.com/Jfbg8uD.png"
        static let nameEditTitle = "Item Name"
        static let priceEditTitle = "Item Price"
        static let imageUrlEditTitle = "Item Image URL (Default is TouchBistro Logo)"
        static let itemEditNavigationTitle = "Edit %@"
    }
    
    var item: MenuItem?
    {
        didSet {
            updateTitle()
        }
    }
    
    var group: MenuGroup!

    func updateTitle() {
        navigationItem.title = String(format: ItemEditTableViewConstants.itemEditNavigationTitle, item?.name ?? "Item")
    }
    
    func didFailEditing(withErrorMessage message: String, editType: EditType) {
        view.makeToast(message, duration: 3.0, position: .center)
    }
    
    func didFinishEditing(editType: EditType, value: Any) {
        _ = editType.update(object: item!, value: value)
        resignFirstResponder()
        view.makeToast(ValidatorConstants.successMessage, duration: 3.0, position: .center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: ItemEditTableViewConstants.itemEditCellNib, bundle: Bundle.main),
                           forCellReuseIdentifier: ItemEditTableViewConstants.itemEditCellReuseIdentifier)
        tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ItemEditTableViewConstants.nameEditTitle
        case 1:
            return ItemEditTableViewConstants.priceEditTitle
        case 2:
            return ItemEditTableViewConstants.imageUrlEditTitle
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemEditTableViewConstants.itemEditCellReuseIdentifier, for: indexPath) as! MenuEditTableViewCell
        cell.delegate = self

        switch indexPath.section {
            // Edit Name
        case 0:
            cell.editType = EditType.itemNameEdit
            cell.initialValue = item?.name
            // Edit Price
        case 1:
            cell.editType = EditType.priceEdit
            cell.initialValue = String(item?.price ?? 0)
        case 2:
            cell.editType = EditType.itemImageUrlEdit
            cell.initialValue = item?.imageUrl?.absoluteString ?? ItemEditTableViewConstants.touchBistroLogoImageURL
        default:
            break
        }
        
        return cell
    }
}

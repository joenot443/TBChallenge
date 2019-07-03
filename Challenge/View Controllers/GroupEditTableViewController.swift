//
//  GroupEditTableViewController.swift
//  Challenge
//
//  Created by Joe Crozier on 2019-06-27.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import Toast_Swift

class GroupEditTableViewController: UITableViewController, MenuEditDelegate {
    struct GroupEditTableViewConstants {
        static let editCellReuseIdentifier = "MenuEditCell"
        static let editCellNib = "MenuEditTableViewCell"
        static let nameEditTitle = "Group Name"
        static let touchBistroLogoImageURL = "https://i.imgur.com/Jfbg8uD.png"
        static let imageUrlEditTitle = "Group Image URL (Default is TouchBistro Logo)"
        static let groupEditNavigationTitle = "Edit %@"
    }
    
    var group: MenuGroup? {
        didSet {
            navigationItem.title = String(format: GroupEditTableViewConstants.groupEditNavigationTitle, group?.name ?? "Group")
        }
    }
    
    func didFailEditing(withErrorMessage message: String, editType: EditType) {
        view.makeToast(message, duration: 3.0, position: .center)
    }
    
    func didFinishEditing(editType: EditType, value: Any) {
        _ = editType.update(object: group!, value: value)
        resignFirstResponder()
        view.makeToast(ValidatorConstants.successMessage, duration: 3.0, position: .center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: GroupEditTableViewConstants.editCellNib, bundle: Bundle.main),
                           forCellReuseIdentifier: GroupEditTableViewConstants.editCellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return GroupEditTableViewConstants.nameEditTitle
        case 1:
            return GroupEditTableViewConstants.imageUrlEditTitle
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupEditTableViewConstants.editCellReuseIdentifier, for: indexPath) as! MenuEditTableViewCell
        cell.delegate = self
        
        switch indexPath.section {
        // Edit Name
        case 0:
            cell.editType = EditType.groupNameEdit
            cell.initialValue = group?.name
        case 1:
            cell.editType = EditType.groupImageUrlEdit
            cell.initialValue = group?.imageUrl?.absoluteString ?? GroupEditTableViewConstants.touchBistroLogoImageURL
        default:
            break
        }
        
        return cell
    }
}

//
//  NewGroupTableViewController.swift
//  Challenge
//
//  Created by Joe Crozier on 2019-07-02.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import Toast_Swift

class NewGroupTableViewController: GroupEditTableViewController {
    var groupName: String?
    var imageUrl: URL?
    lazy private var doneBarButtonItem: UIBarButtonItem = { [weak self] in
       return UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonPressed))
    }()
    
    struct NewGroupTableViewConstants {
        static let newGroupTitleKey = "New Group"
        static let newGroupSuccessMessage = "Successfully created a new Group"
        static let touchBistroLogoImageURL = "https://i.imgur.com/Jfbg8uD.png"

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.title = NewGroupTableViewConstants.newGroupTitleKey
        // Give our imageURL a default value for convenience's sake
        imageUrl = URL(string: NewGroupTableViewConstants.touchBistroLogoImageURL)
    }
    
    override func didFinishEditing(editType: EditType, value: Any) {
        switch editType {
        case .groupNameEdit: groupName = value as? String
        case .groupImageUrlEdit: imageUrl = value as? URL
        default: break
        }
        resignFirstResponder()
        updateDoneButtonEnabled()
    }
    
    func updateDoneButtonEnabled() {
        doneBarButtonItem.isEnabled = groupName != nil && !(groupName!.isEmpty) && imageUrl != nil
    }
    
    @objc func doneButtonPressed() {
        let result = MenuManager.shared.addGroup(name: groupName!, imageUrl: imageUrl!)
        if let message = result.error {
            view.makeToast(message, duration: 3.0, position: .center)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}

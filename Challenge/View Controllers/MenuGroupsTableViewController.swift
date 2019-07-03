//
//  ATableViewController.swift
//  TouchBistroChallenge
//
//  Created by Joe Crozier on 2019-06-26.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import Toast_Swift

class MenuGroupsTableViewController: UITableViewController {
    
    var menuGroups: [MenuGroup] = []
    var selectedGroup: MenuGroup?
    
    struct MenuGroupsTableViewConstants {
        static let menuGroupCellReuseIdentifier = "MenuGroupCell"
        static let menuGroupCellNib = "MenuGroupTableViewCell"
        static let menuItemsSegue = "itemsSegue"
        static let menuEditSegue = "editGroupSegue"
        static let menuNewSegue = "newGroupSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: MenuGroupsTableViewConstants.menuGroupCellNib, bundle: Bundle.main),
                                 forCellReuseIdentifier: MenuGroupsTableViewConstants.menuGroupCellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.allowsSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil), UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonPressed))], animated: false)
        
        loadMenu()
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        tableView.reloadData()
    }

    func loadMenu() {
        let result = MenuManager.shared.menuGroups()
        if let error = result.error {
            view.makeToast(error, duration: 3.0, position: .center)
        } else {
            menuGroups = result.groups ?? []
        }
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: MenuGroupsTableViewConstants.menuNewSegue, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMenu()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete, let cell = tableView.cellForRow(at: indexPath) as? MenuGroupTableViewCell {
            MenuManager.shared.delete(group: cell.group)
            tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuGroupsTableViewConstants.menuGroupCellReuseIdentifier, for: indexPath) as! MenuGroupTableViewCell
        cell.group = menuGroups[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = menuGroups[indexPath.row]
        if self.isEditing {
            performSegue(withIdentifier: MenuGroupsTableViewConstants.menuEditSegue, sender: nil)
        } else {
            performSegue(withIdentifier: MenuGroupsTableViewConstants.menuItemsSegue, sender: nil)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MenuGroupsTableViewConstants.menuItemsSegue {
            let destination = segue.destination as! MenuItemsTableViewController
            destination.group = selectedGroup
        } else if segue.identifier == MenuGroupsTableViewConstants.menuEditSegue {
            let destination = segue.destination as! GroupEditTableViewController
            destination.group = selectedGroup
        }
    }

}

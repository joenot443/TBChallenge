//
//  MenuItemsTableViewController.swift
//  TouchBistroChallenge
//
//  Created by Joseph Crozier on 2019-06-26.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit

class MenuItemsTableViewController: UITableViewController {
    struct MenuItemsTableViewConstants {
        static let menuItemCellReuseIdentifier = "MenuItemCell"
        static let menuItemCellNib = "MenuItemTableViewCell"
        static let menuItemEditSegue = "itemEditSegue"
        static let menuNewItemSegue = "newItemSegue"
        static let menuItemsTitle = "%@ Menu"
    }
    
    var group: MenuGroup! {
        didSet {
            navigationItem.title = String(format: MenuItemsTableViewConstants.menuItemsTitle, group.name ?? "Default")
        }
    }
    var selectedItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: MenuItemsTableViewConstants.menuItemCellNib, bundle: Bundle.main),
                           forCellReuseIdentifier: MenuItemsTableViewConstants.menuItemCellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = false
        setToolbarItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil), UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonPressed))], animated: false)


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func addButtonPressed() {
        performSegue(withIdentifier: MenuItemsTableViewConstants.menuNewItemSegue, sender: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.items?.count ?? 0
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete, let cell = tableView.cellForRow(at: indexPath) as? MenuItemTableViewCell {
            MenuManager.shared.delete(item: cell.item)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemsTableViewConstants.menuItemCellReuseIdentifier, for: indexPath) as! MenuItemTableViewCell
        cell.item = group.items?[indexPath.row] as? MenuItem

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuItemTableViewCell
        selectedItem = cell.item
        performSegue(withIdentifier: MenuItemsTableViewConstants.menuItemEditSegue, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == MenuItemsTableViewConstants.menuItemEditSegue {
            let destination = segue.destination as! ItemEditTableViewController
            destination.item = selectedItem
        } else if segue.identifier == MenuItemsTableViewConstants.menuNewItemSegue {
            let destination = segue.destination as! NewItemTableViewController
            destination.group = group
        }
    }

}

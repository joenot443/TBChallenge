//
//  MenuManager.swift
//  TouchBistroChallenge
//
//  Created by Joseph Crozier on 2019-06-25.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import CoreData

struct MenuOperationResult {
    let success: Bool
    let error: String?
}

struct MenuGroupsResult {
    let groups: [MenuGroup]?
    let error: String?
}
class MenuManager: NSObject {
    
    static let shared = MenuManager()
    
    let context: NSManagedObjectContext = {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.persistentContainer.viewContext
    }()
    
    struct MenuManagerConstants {
        static let menuGroupName = "MenuGroup"
        static let menuItemName = "MenuItem"
        static let coreDataError = "A general Core Data error occurred."
    }
    
    func clearMenu() throws {
        let deleteGroupRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: MenuManagerConstants.menuItemName))
        let deleteItemsRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: MenuManagerConstants.menuGroupName))
        try context.execute(deleteGroupRequest)
        try context.execute(deleteItemsRequest)
    }
    
    func saveMenuContext() -> MenuOperationResult {
        do {
            try context.save()
            return MenuOperationResult(success: true, error: nil)
        } catch {
            return MenuOperationResult(success: false, error: error.localizedDescription)
        }
    }
    
    func addGroup(name: String, imageUrl: URL) -> MenuOperationResult {
        guard let groupDescription = NSEntityDescription.entity(forEntityName: MenuManagerConstants.menuGroupName, in: context) else {
           return MenuOperationResult(success: false, error: MenuManagerConstants.coreDataError)
        }
        
        let group = MenuGroup.init(entity: groupDescription, insertInto: context)
        group.name = name
        group.imageUrl = imageUrl
        return saveMenuContext()
    }
    
    func addItem(name: String, price: Float, imageUrl: URL, group: MenuGroup) -> MenuOperationResult {
        guard let itemDescription = NSEntityDescription.entity(forEntityName: MenuManagerConstants.menuItemName, in: context) else {
            return MenuOperationResult(success: false, error: MenuManagerConstants.coreDataError)
        }
        let item = MenuItem.init(entity: itemDescription, insertInto: context)
        item.name = name
        item.price = price
        item.imageUrl = imageUrl
        item.group = group
        group.addToItems(item)
        return saveMenuContext()
    }
    
    @discardableResult func delete(group: MenuGroup) -> MenuOperationResult {
        context.delete(group)
        group.items?.forEach { context.delete($0 as! MenuItem) }
        return saveMenuContext()
    }
    
    @discardableResult func delete(item: MenuItem) -> MenuOperationResult {
        context.delete(item)
        return saveMenuContext()
    }
    
    func update(group: MenuGroup, name: String) -> MenuOperationResult {
        group.name = name
        return saveMenuContext()
    }
    
    func update(group: MenuGroup, imageUrl: URL) -> MenuOperationResult {
        group.imageUrl = imageUrl
        return saveMenuContext()
    }
    
    func update(item: MenuItem, name: String) -> MenuOperationResult {
        item.name = name
        return saveMenuContext()
    }
    
    func update(item: MenuItem, price: Float) -> MenuOperationResult {
        item.price = price
        return saveMenuContext()
    }
    
    func update(item: MenuItem, imageUrl: URL) -> MenuOperationResult {
        item.imageUrl = imageUrl
        return saveMenuContext()
    }
    
    func prepopulateMenu() {
        if let jsonPath = Bundle.main.path(forResource: "DefaultMenu", ofType: "json") {
            do {
                try clearMenu()
                
                let data = try Data(contentsOf: URL.init(fileURLWithPath: jsonPath))
                let menuData = try JSONDecoder().decode(MenuData.self, from: data)
                guard let groupDescription = NSEntityDescription.entity(forEntityName: MenuManagerConstants.menuGroupName, in: context),
                    let itemDescription = NSEntityDescription.entity(forEntityName: MenuManagerConstants.menuItemName, in: context) else {
                        return
                }
                
                menuData.groups.forEach { (groupData) in
                    let group = MenuGroup.init(entity: groupDescription, insertInto: context)
                    group.name = groupData.name
                    group.imageUrl = URL(string: groupData.imageUrl)
                    group.items = NSOrderedSet(array: groupData.items.map({ (itemData) -> MenuItem in
                        let item = MenuItem(entity: itemDescription, insertInto: context)
                        item.name = itemData.name
                        item.price = itemData.price
                        item.group = group
                        item.imageUrl = URL(string: itemData.imageUrl)
                        return item
                    }))
                }
                try context.save()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func menuGroups() -> MenuGroupsResult {
        let groupsFetchRequest = NSFetchRequest<MenuGroup>(entityName: "MenuGroup")
        do {
            let groups = try context.fetch(groupsFetchRequest)
            return MenuGroupsResult(groups: groups, error: nil)
        } catch {
            return MenuGroupsResult(groups: nil, error: error.localizedDescription)
        }
    }
    
}

//
//  CoreDataManager.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 24.07.2022.
//

import Foundation
import CoreData

// MARK: - CoreData Manager - Singletone

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    init() {
    }
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    lazy var entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes_Test_App_MVVM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

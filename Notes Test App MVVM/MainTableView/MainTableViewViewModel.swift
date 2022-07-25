//
//  MainTableViewViewModel.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 18.07.2022.
//

import Foundation
import CoreData
import UIKit

// MARK: - Protocol

protocol MainTableViewModelProtocol {
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> { get }
    func addNewObject(title: String, text: String)
    func deleteObject(noteToDelete: Note)
    func saveNewObject()
}

// MARK: - View Model Class

class MainTableViewModel: MainTableViewModelProtocol {
    
    // MARK: - FetchResultController
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let context = CoreDataManager.instance.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    // MARK: CoreData Functions
    // may be pass to CoreDataManager
    
    func deleteObject(noteToDelete: Note) {
        let context = CoreDataManager.instance.context
        context.delete(noteToDelete)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveNewObject() {
        let context = CoreDataManager.instance.context
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addNewObject(title: String, text: String) {
        let context = CoreDataManager.instance.context
        guard let entity = CoreDataManager.instance.entity else { return }
        
        let noteObject = Note(entity: entity, insertInto: context)
        noteObject.title = title
        noteObject.text = text
        noteObject.id = UUID()
        noteObject.date = Date()
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


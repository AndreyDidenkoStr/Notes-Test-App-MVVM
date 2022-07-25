//
//  NoteDetailViewViewModel.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 23.07.2022.
//

import Foundation
import CoreData

// MARK: - Protocol

protocol NoteDetailViewViewModelProtocol {
    var noteObject: Note? { get }
    func addNewObject(title: String, text: String)
}

// MARK: - View Model Class

class NoteDetailViewViewModel: NoteDetailViewViewModelProtocol {
    
    var noteObject: Note? 
    
    func addNewObject(title: String, text: String) {
        let context = CoreDataManager.instance.context
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        
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

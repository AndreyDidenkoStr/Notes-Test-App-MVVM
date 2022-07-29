//
//  MainTableTableViewController.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 18.07.2022.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    private var viewModel: MainTableViewModelProtocol?
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        viewModel = MainTableViewModel()
        viewModel?.fetchResultController.delegate = self
        
        do {
            try viewModel?.fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddButton))
    }
    
    @objc func pressAddButton() {
        navigationController?.pushViewController(NoteDetailViewController(), animated: true)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = viewModel?.fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let note = viewModel?.fetchResultController.object(at: indexPath) as? Note
        cell.textLabel?.text = note?.title
        
        if let date = note?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let stringDate = dateFormatter.string(from: date)
            cell.detailTextLabel?.text = stringDate
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = viewModel?.fetchResultController.object(at: indexPath) as! Note
        let detailVC = NoteDetailViewController()
        detailVC.note = note
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = viewModel?.fetchResultController.object(at: indexPath) as! Note
            viewModel?.deleteObject(noteToDelete: note)
        } else if editingStyle == .insert {
        }    
    }
}

// MARK: FetchedResultsController Delegate

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let note = viewModel?.fetchResultController.object(at: indexPath) as! Note
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = note.title
            }
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


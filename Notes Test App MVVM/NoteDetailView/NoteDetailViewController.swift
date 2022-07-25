//
//  NoteDetailViewController.swift
//  Notes Test App MVVM
//
//  Created by Andrey Kapitalov on 23.07.2022.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var note: Note?
    private var viewModel: NoteDetailViewViewModelProtocol?
    
    // MARK: - lazy properties UI Elements
    
    lazy var datelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "Note Title"
        return label
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "Note Text"
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        return textField
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 3
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        view.backgroundColor = .white
        viewModel = NoteDetailViewViewModel()
        addUI()
        setupConstraints()
        addBurButtons()
        if note != nil {
            setValuesWithNote()
        }
    }
    
    func addBurButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(pressSaveButton))
    }
    
    @objc func pressSaveButton() {
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "Enter Title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if note == nil {
                viewModel?.addNewObject(title: titleTextField.text ?? "New Note", text: textView.text)
                navigationController?.popToRootViewController(animated: true)
            } else {
                if let note = note {
                    note.title = titleTextField.text
                    note.text = textView.text
                    CoreDataManager.instance.saveContext()
                    navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - UI
    
    func addUI() {
        
        view.addSubview(datelabel)
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        view.addSubview(titleTextField)
        view.addSubview(textView)
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            datelabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datelabel.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            datelabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            datelabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            titleTextField.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
    
    func setValuesWithNote() {
        guard let currentNote = note else { return }
        titleTextField.text = currentNote.title
        textView.text = currentNote.text
        
        // need func for date
        guard let date = currentNote.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = dateFormatter.string(from: date)
        datelabel.text = stringDate
    }

}

//
//  NotepadViewController.swift
//  Notepad
//
//  Created by Rachel Lee on 6/30/24.
//

import UIKit
import CoreData

class NotepadViewController: UIViewController {
    //MARK: - Global Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var note: Note?
    
    var noteTitle: String!
    
    private var navigationTitleTextField: UITextField {
        return navigationItem.titleView as! UITextField
    }
    
    //MARK: - Subviews
    
    private lazy var safeAreaView: UIView = {
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        return safeAreaView
    }()
    
    private lazy var textAreaView: UITextView = {
        let textAreaView = UITextView()
        textAreaView.font = .systemFont(ofSize: 20)
        textAreaView.translatesAutoresizingMaskIntoConstraints = false
        return textAreaView
    }()
    
    private lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.font = .preferredFont(forTextStyle: .title1)
        titleTextField.textAlignment = .center
        titleTextField.placeholder = "Title"
        return titleTextField
    }()
    
    //MARK: - Subview Constraints
    
    private func setupSubviewConstraints() {
        safeAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        textAreaView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 0).isActive = true
        textAreaView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: 0).isActive = true
        textAreaView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 0).isActive = true
        textAreaView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: 0).isActive = true
    }

    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Root view properties
        view.backgroundColor = .white
        
        /// View hierarchy
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(textAreaView)
        
        /// Navigation bar properties
        navigationItem.titleView = titleTextField
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        
        /// Load initial note data
        loadNote()
    }
    
    override func viewWillLayoutSubviews() {
        setupSubviewConstraints()
    }
    
    //MARK: - UI Actions
    
    @objc private func savePressed() {
        /// Create note in context if it doesn't already exist
        if note == nil { note = Note(context: context) }

        /// Update the context note with values from UI
        note!.title = navigationTitleTextField.text
        note!.body = textAreaView.text
        
        /// Save note to persistentContainer
        saveNote()
    }
    
    //MARK: - Data Manipulation Methods
    private func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    private func loadNote(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            note = try context.fetch(request).first
            
        } catch {
            print("Error loading context, \(error)")
        }
        
        /// Reload UI with new note entity
        if let safeNote = note {
            textAreaView.text = safeNote.body
            navigationTitleTextField.text = safeNote.title
        }
    }
    
}

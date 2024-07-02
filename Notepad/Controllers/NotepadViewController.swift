//
//  NotepadViewController.swift
//  Notepad
//
//  Created by Rachel Lee on 6/30/24.
//

import UIKit
import CoreData

class NotepadViewController: UIViewController {
    //MARK: - Variables
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var note: Note?
    
    //MARK: - UI Views
    
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
    
    private lazy var navigationTitleField: UITextField = {
        let navigationTitleField = UITextField()
        navigationTitleField.placeholder = "Title"
        navigationTitleField.font = .systemFont(ofSize: 20)
        navigationTitleField.translatesAutoresizingMaskIntoConstraints = false
        return navigationTitleField
    }()
    
    private func constrainViews() {
        safeAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        textAreaView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor, constant: 0).isActive = true
        textAreaView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor, constant: 0).isActive = true
        textAreaView.topAnchor.constraint(equalTo: safeAreaView.topAnchor, constant: 0).isActive = true
        textAreaView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor, constant: 0).isActive = true
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Root view properties
        view.backgroundColor = .white
        
        /// View hierarchy
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(textAreaView)
        
        /// View constraints
        constrainViews()
        
        /// Navigation bar properties
        navigationItem.titleView = navigationTitleField
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        
        /// Load initial note data
        loadNote()
    }
    
    //MARK: - UI Actions
    
    @objc private func savePressed() {
        /// Create note in context if it doesn't already exist
        if note == nil { note = Note(context: context) }

        /// Update the context note with values from UI
        note!.title = (navigationItem.titleView as! UITextField).text
        note!.body = textAreaView.text
        
        /// Save note to persistentContainer
        saveNote()
    }
    
    //MARK: - Data Manipulation Methods
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadNote(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            note = try context.fetch(request).first
            
        } catch {
            print("Error loading context, \(error)")
        }
        
        /// Reload UI with new note entity
        if let safeNote = note {
            textAreaView.text = safeNote.body
            (navigationItem.titleView as! UITextField).text = safeNote.title
        }
    }
    
}


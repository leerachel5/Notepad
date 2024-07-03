//
//  NotesListViewController.swift
//  Notepad
//
//  Created by Rachel Lee on 7/2/24.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    //MARK: - Global Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes: [Note] = []
    
    //MARK: - Subviews
    
    private lazy var safeAreaView: UIView = {
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        return safeAreaView
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteListCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    //MARK: - Subview Constraints
    
    private func setupSubviewConstraints() {
        safeAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        safeAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor).isActive = true
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Root view properties
        view.backgroundColor = .white
        
        /// View hierarchy
        view.addSubview(safeAreaView)
        safeAreaView.addSubview(tableView)
        
        /// Setup navigationBar properties
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        
        /// Load initial note data
        loadNotes()
    }
    
    //MARK: - UI Interactions
    @objc private func addPressed() {
        /// Create UIAlertVC
        let alert = UIAlertController(title: "Add new note", message: "", preferredStyle: .alert)
        
        /// Embed UITextField in UIAlertVC
        var textField: UITextField?
        
        alert.addTextField { field in
            field.placeholder = "Note title"
            textField = field
        }
        
        /// Create `Cancel` and `Confirm`actions, then add to UIAlertVC
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            /// Create new Note object, save to context, and reload tableView data
            if let field = textField {
                
                let note = Note(context: self.context)
                note.title = field.text
                note.body = ""
                
                self.notes.append(note)
                
                self.saveNotes()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        
        /// Present UIAlertVC
        present(alert, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        setupSubviewConstraints()
    }
    
    //MARK: - Data Manipulation Methods
    
    private func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        /// Reload tableView with new notes
        tableView.reloadData()
    }
    
    private func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            notes = try context.fetch(request)
            
        } catch {
            print("Error loading context, \(error)")
        }
        
        /// Reload tableView with fetched notes
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource Protocol

extension NotesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { notes.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = notes[indexPath.row].title
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate Protocol

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Navigate to NotepadViewController when cell is selected
        let notepadViewController = NotepadViewController()
        notepadViewController.note = notes[indexPath.row]
        self.navigationController?.pushViewController(notepadViewController, animated: true)
    }
}

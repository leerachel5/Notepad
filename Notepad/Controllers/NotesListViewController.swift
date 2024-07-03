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
    
    var titles: [String] = []
    
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
        
        /// Load initial note data
        loadNotes()
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
    }
    
    private func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            let notes = try context.fetch(request)
            titles = notes.map { $0.title! }
            
        } catch {
            print("Error loading context, \(error)")
        }
        
        /// Reload tableView with fetched note titles
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource Protocol

extension NotesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { titles.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate Protocol

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notepadViewController = NotepadViewController()
        notepadViewController.noteTitle = titles[indexPath.row]
        self.navigationController?.pushViewController(notepadViewController, animated: true)
    }
}

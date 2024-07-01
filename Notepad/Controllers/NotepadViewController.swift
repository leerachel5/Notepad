//
//  NotepadViewController.swift
//  Notepad
//
//  Created by Rachel Lee on 6/30/24.
//

import UIKit

class NotepadViewController: UIViewController {
    //MARK: - Variables
    
    static let safeAreaInsets: UIEdgeInsets = .zero
    
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
        navigationItem.title = "Notepad"
    }
}


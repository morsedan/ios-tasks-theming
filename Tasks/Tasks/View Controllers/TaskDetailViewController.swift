//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Andrew R Madsen on 8/11/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        setupAppearances()
    }
    
    func setupAppearances() {
        view.backgroundColor = AppearanceHelper.deepPurple
        nameTextField.backgroundColor = AppearanceHelper.deepPurple
        nameTextField.layer.borderColor = AppearanceHelper.greyText.cgColor
        nameTextField.layer.borderWidth = 0.3
        nameTextField.layer.cornerRadius = 8
        nameLabel.textColor = AppearanceHelper.greyText
        
        priorityLabel.textColor = AppearanceHelper.greyText
        
        notesLabel.textColor = AppearanceHelper.greyText
        
        notesTextView.backgroundColor = AppearanceHelper.deepPurple
        notesTextView.layer.borderWidth = 0.3
        notesTextView.layer.borderColor = AppearanceHelper.greyText.cgColor
        notesTextView.layer.cornerRadius = 8
    }

    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        let priorityIndex = priorityControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]
        let notes = notesTextView.text
        
        if let task = task {
            // Editing existing task
            task.name = name
            task.priority = priority.rawValue
            task.notes = notes
            taskController.put(task: task)
        } else {
            let task = Task(name: name, notes: notes, priority: priority)
            taskController.put(task: task)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        priorityControl.selectedSegmentIndex = TaskPriority.allPriorities.index(of: priority)!
        notesTextView.text = task?.notes
    }
    
    // MARK: Properties
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    var taskController: TaskController!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priorityControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
}

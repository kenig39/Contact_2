//
//  ViewController.swift
//  Contact
//
//  Created by Alexander on 07.04.2024.
//

import UIKit

class ViewController: UIViewController{
    
    var storage: ContactStorageProtocol!
    
    var tableView = UITableView()
    
    var contacts: [ContactProtocol] = [] {
        didSet {
            contacts.sort{ $0.title < $1.title}
            // save contact
            storage.save(contacts: contacts)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "создать контакт", style: .done, target: self, action: #selector(showNewContactAlert))
        
        setupUI()
        
        storage = ContactStorage() as ContactStorageProtocol
        loadContacts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
       
    }
    
    private func loadContacts() {
        contacts = storage.load()
    }
    
    @objc func showNewContactAlert() {
        let alertController = UIAlertController(title: "Создать новый контакт", message: "введите имя и тедлефон", preferredStyle: .alert)
        
        alertController.addTextField() { textfield in
            textfield.placeholder = "Имя"

        }
            alertController.addTextField() { textfield in
                textfield.placeholder = "Номер телефона"
                
            }
        
        let createButton = UIAlertAction(title: "создать", style: .default, handler: { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else {
                return
            }
            
            let contact = Contact(title: contactName, number: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
            
        })
        
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
                
                // добавляем кнопки в Alert Controller
                alertController.addAction(cancelButton)
                alertController.addAction(createButton)
                
                // отображаем Alert Controller
                self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
           var configuration = cell.defaultContentConfiguration()
           // имя контакта
           configuration.text = contacts[indexPath.row].title
           // номер телефона контакта
        configuration.secondaryText = contacts[indexPath.row].number
           cell.contentConfiguration = configuration
       }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           var cell: UITableViewCell
           if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
               print("Используем старую ячейку для строки с индексом \(indexPath.row)")
               cell = reuseCell
           } else {
               print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
               cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
           }
           configure(cell: &cell, for: indexPath)
           return cell
       }
   
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            // удаляем контакт
            self.contacts.remove(at: indexPath.row)
            // заново формируем табличное представление
            tableView.reloadData()
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

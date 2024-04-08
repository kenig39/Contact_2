//
//  model.swift
//  Contact
//
//  Created by Alexander on 07.04.2024.
//

import Foundation

protocol ContactProtocol {
    var title: String {get set}
    
    var number: String {get set}
}



struct Contact: ContactProtocol {
    var title: String
    var number: String
}

protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    
    func save(contacts: [ContactProtocol])
    
}

class ContactStorage: ContactStorageProtocol {
    
    private var storage = UserDefaults.standard
    
    var storageKey: String = "contacts"
    
    private enum ContactKey:String {
        case title
        case phone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, number: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String: String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.number
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}



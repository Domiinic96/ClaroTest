//
//  ContactRepositoryProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//

import Foundation



@objc final class ContactRepository: NSObject, ContactRepositoryProtocol {
    
    private let storage: ContactStorageProtocol
    @objc init(storage: ContactStorageProtocol) {
        self.storage = storage
    }
    
    @objc func getContacts() -> [Contact] {
        storage.fetch()
    }
    
    @objc func addContact(_ contact: Contact) {
        var contacts = storage.fetch()
        contacts.append(contact)
        storage.save(contacts)
    }
    
    @objc func deleteContact(_ contact: Contact) {
        
        var contacts = getContacts()
        contacts.removeAll(where: { $0.id == contact.id })
        storage.save(contacts)
    }
    
    @objc func deleteAll() {
        storage.removeAll()
    }
}

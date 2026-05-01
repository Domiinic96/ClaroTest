//
//  ContactStorageProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import Foundation


@objc final class ContactStorage: NSObject, ContactStorageProtocol {
    
    func save(_ contacts: [Contact]) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: contacts, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: Constants.key)
    }
    
    func fetch() -> [Contact] {
        guard let data = UserDefaults.standard.data(forKey: Constants.key),
              let contacts = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Contact.self], from: data) as? [Contact] else {
            return []
        }
        return contacts
    }

    func removeAll() {
        UserDefaults.standard.removeObject(forKey: Constants.key)
    }
    
    
}

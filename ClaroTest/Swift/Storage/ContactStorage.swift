//
//  ContactStorageProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import Foundation


@objc final class ContactStorage: NSObject, ContactStorageProtocol {
    
    func save(_ contacts: [Contact]) {
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(contacts)
        UserDefaults.standard.set(data, forKey: Constants.key)
    }
    
    func fetch() -> [Contact] {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: Constants.key),
              let contacts = try? decoder.decode([Contact].self, from: data) else {
            return []
        }
        return contacts
    }

    func removeAll() {
        UserDefaults.standard.removeObject(forKey: Constants.key)
    }
    
    
}

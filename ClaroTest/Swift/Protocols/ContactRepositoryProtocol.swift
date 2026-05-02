//
//  ContactRepositoryProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//

import Foundation
protocol ContactRepositoryProtocol {
    func getContacts() -> [Contact]
    func addContact(_ contact: Contact)
    func deleteContact(_ contact:Contact)
    func deleteAll()
}

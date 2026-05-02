//
//  MockRepository.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//
@testable import ClaroTest

final class MockRepository: ContactRepositoryProtocol {
    
    var savedContact: Contact?
    
    func getContacts() -> [Contact] { return [savedContact!] }
    
    func addContact(_ contact: Contact) {
        savedContact = contact
    }
    
    func deleteContact(_ contact: Contact) {
        savedContact = nil
    }
    func deleteAll() {
        savedContact = nil
    }
}

final class MockImageService: ImageServiceProtocol {
    
    func fetchRandomImage() async -> String {
        return "https://test.com/image.jpg"
    }
}

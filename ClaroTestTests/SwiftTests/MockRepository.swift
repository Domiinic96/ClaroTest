//
//  MockRepository.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//
@testable import ClaroTest
import Foundation

final class MockRepository: ContactRepositoryProtocol {
    
    var savedContact: ClaroTest.Contact?
    
    func getContacts() -> [ClaroTest.Contact] { return [savedContact!] }
    
    func addContact(_ contact: ClaroTest.Contact) {
        savedContact = contact
    }
    
    func deleteContact(_ contact: ClaroTest.Contact) {
        savedContact = nil
    }
    func deleteAll() {
        savedContact = nil
    }
}

final class MockImageService: ImageServiceProtocol {
    
    let result: Result<String, Error>
    
    init(result: Result<String, Error>) {
        self.result = result
    }
    
    func fetchRandomImage() async -> Result<String, Error> {
        return result
    }
}

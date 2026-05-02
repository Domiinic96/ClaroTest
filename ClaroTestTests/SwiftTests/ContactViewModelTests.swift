//
//  ContactViewModelTests.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//


import XCTest
@testable import ClaroTest

final class ContactViewModelTests: XCTestCase {
    
    var repo:MockRepository!
    var imageService:MockImageService!
    
    override func setUp() {
        repo = MockRepository()
        imageService = MockImageService()
        
    }
    

    @MainActor
    func testSaveContact() {
        
        
        let vm = ContactViewModel(repository: repo,imageService: imageService)
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        vm.save()
        
        XCTAssertNotNil(repo.savedContact)
        XCTAssertEqual(repo.savedContact?.name, "Luis")
        XCTAssertEqual(repo.savedContact?.phone, "8291234567")
    }
    
    @MainActor
    func testLoadImage() async {
        
        let vm = ContactViewModel(
            repository: repo,
            imageService: imageService
        )
        
        await vm.loadImage()
        
        let imageUrl = vm.imageUrl
        
        XCTAssertEqual(imageUrl, "https://test.com/image.jpg")
    }
    
    @MainActor
    func testSaveGeneratesId() {
        let vm = ContactViewModel(repository: repo, imageService: imageService)
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        
        vm.save()
        
        XCTAssertFalse(repo.savedContact?.id.isEmpty ?? true)
    }
    
    @MainActor func testDeleteContact() {
        let vm = ContactViewModel(repository: repo, imageService: imageService)
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        vm.save()
        repo.deleteContact(repo.savedContact!)
        XCTAssertNil(repo.savedContact)
    }
    
    
    @MainActor func testGetSavedContact() {
        let vm = ContactViewModel(repository: repo, imageService: imageService)
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        vm.save()
        let savedContact = repo.savedContact
        XCTAssertNotNil(savedContact)
    }
    
    @MainActor func testDeleteAll() {
        let vm = ContactViewModel(repository: repo, imageService: imageService)
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        vm.save()
        repo.deleteAll()
        XCTAssertNil(repo.savedContact)
    }
    
    @MainActor func testGetContacts() {
        let vm = ContactViewModel(repository: repo, imageService: imageService)
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        vm.save()
        XCTAssertTrue(repo.getContacts().count>0)
    }

    
}

//
//  ContactViewModelTests.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//


import XCTest
@testable import ClaroTest

final class ContactViewModelTests: XCTestCase {

    @MainActor func testSaveContact() {
        
        let repo = MockRepository()
        let imageService = MockImageService()
        
        let vm = ContactViewModel(
            repository: repo,
            imageService: imageService
        )
        
        vm.name = "Luis"
        vm.lastName = "Santana"
        vm.phone = "8291234567"
        vm.imageUrl = "url"
        
        vm.save()
        
        XCTAssertNotNil(repo.savedContact)
        XCTAssertEqual(repo.savedContact?.name, "Luis")
        XCTAssertEqual(repo.savedContact?.phone, "8291234567")
    }
    
    func testLoadImage() async {
        
        let repo = MockRepository()
        let imageService = MockImageService()
        
        let vm = await ContactViewModel(
            repository: repo,
            imageService: imageService
        )
        
        await vm.loadImage()
        
        let imageUrl = await vm.imageUrl
        
        XCTAssertEqual(imageUrl, "https://test.com/image.jpg")
    }
    
    @MainActor func testSaveGeneratesId() {
        let repo = MockRepository()
        let vm = ContactViewModel(repository: repo, imageService: MockImageService())
        
        vm.save()
        
        XCTAssertFalse(repo.savedContact?.id.isEmpty ?? true)
    }
}

//
//  ContactViewModelProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import Foundation

final class ContactViewModel: ContactViewModelProtocol, ObservableObject {
    
    @Published var name = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var imageUrl = ""
    @Published var isloadingImage: Bool = false
    
    private let repository: ContactRepositoryProtocol
    private let imageService: ImageServiceProtocol
    
    //var onSave: (([Contact]) -> Void)?
    
    init(repository: ContactRepositoryProtocol,
         imageService: ImageServiceProtocol) {
        self.repository = repository
        self.imageService = imageService
    }
    
    func loadImage() async {
        let url = await imageService.fetchRandomImage()
        imageUrl = url
    }
    
    func save() {
        isloadingImage = true
        defer { isloadingImage = false }
        let contact = Contact()
        contact.id = UUID().uuidString
        contact.name = name
        contact.lastName = lastName
        contact.phone = phone
        contact.imageUrl = imageUrl
        repository.addContact(contact)
    }
}

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
    @Published var isSaving: Bool = false
    
    private let repository: ContactRepositoryProtocol
    private let imageService: ImageServiceProtocol
    
    init(repository: ContactRepositoryProtocol,
         imageService: ImageServiceProtocol) {
        self.repository = repository
        self.imageService = imageService
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty &&
        phone.count == 10
    }
    
    func loadImage() async {
        guard !isloadingImage else { return }
        
        isloadingImage = true
        
        defer { isloadingImage = false }
        
        let url = await imageService.fetchRandomImage()
        
        imageUrl = url
        
        
    }
    
    func save() {
        guard isValid, !isSaving else { return }
        
        isSaving = true
        
        let contact = Contact()
        contact.id = UUID().uuidString
        contact.name = name
        contact.lastName = lastName
        contact.phone = phone
        contact.imageUrl = imageUrl
        
        repository.addContact(contact)
        
        isSaving = false
    }
}

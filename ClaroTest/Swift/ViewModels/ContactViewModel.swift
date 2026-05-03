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
    @Published var errorMessage: String? = nil
    
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
        
        let result = await imageService.fetchRandomImage()
        
        switch result {
        case .success(let finalUrl):
            self.imageUrl = finalUrl
            self.errorMessage = nil
        case .failure(let errorMessage):
            self.imageUrl = ""
            self.errorMessage = Constants.image_error_message
            print("error al intentar obtener la imagen: \(errorMessage)")
        }
        
    }
    
    func save() {
        guard isValid, !isSaving else { return }
        
        isSaving = true
        defer {isSaving = false}
        
        let contact = Contact()
        contact.id = UUID().uuidString
        contact.name = name
        contact.lastName = lastName
        contact.phone = phone
        contact.imageUrl = imageUrl
        
        repository.addContact(contact)
        
    }
}

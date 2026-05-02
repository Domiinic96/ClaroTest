//
//  AppContainer.swift
//  ClaroTest
//
//  Created by Luis Santana on 2/5/26.
//


import Foundation

@MainActor
final class AppContainer {

    static let shared = AppContainer()
    let contactStorage: ContactStorageProtocol

    let contactRepository: ContactRepositoryProtocol

    let imageService: ImageServiceProtocol

    private init() {

        self.contactStorage = ContactStorage()

        self.contactRepository = ContactRepository(
            storage: contactStorage
        )

        self.imageService = ImageService()
    }
}

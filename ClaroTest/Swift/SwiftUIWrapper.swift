//
//  SwiftUIWrapper.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import SwiftUI

@objc class SwiftUIWrapper: NSObject {

    @MainActor
    @objc(createAddUser)
     static func createAddUser() -> UIViewController {

        let storage = ContactStorage()
        let repo = ContactRepository(storage: storage)
        let imageService = ImageService()

        let vm = ContactViewModel(repository: repo,
                                  imageService: imageService)


        let view = AddContactView(vm: vm)
        return UIHostingController(rootView: view)
    }
    
    @MainActor
       @objc static func createDetailView(contact: Contact) -> UIViewController {
           let view = ContactDetailView(contact: contact)
           return UIHostingController(rootView: view)
       }
}

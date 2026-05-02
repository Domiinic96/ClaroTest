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
        
        let container = AppContainer.shared
        
        let vm = ContactViewModel(repository: container.contactRepository,
                                  imageService: container.imageService)
        
        
        let view = AddContactView(vm: vm)
        return UIHostingController(rootView: view)
    }
    
    @MainActor
    @objc static func createDetailView(contact: Contact) -> UIViewController {
        let view = ContactDetailView(contact: contact)
        return UIHostingController(rootView: view)
    }
}

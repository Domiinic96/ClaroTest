//
//  ContactDetailView.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import SwiftUI

struct ContactDetailView: View {
    
    let contact: Contact
    
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: contact.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 120)
            
            Text(contact.name)
                .font(.title)
            
            Text(contact.lastName)
                .font(.title2)
            
            Text(contact.phone)
                .font(.body)
        }
        .padding()
        .navigationTitle(Constants.detail)
    }
}

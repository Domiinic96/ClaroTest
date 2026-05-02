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
        VStack(spacing: 24) {
            
            AsyncImage(url: URL(string: contact.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
            }
            .frame(width: 130, height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            Text("\(contact.name) \(contact.lastName)")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 12) {
                Image(systemName: Constants.phone_fill)
                    .foregroundColor(.blue)
                
                Text(contact.phone)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 20)
        .navigationTitle(Constants.detail)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

#Preview {
   
    ContactDetailView(contact: .mock)
}


//
//  AddContactView.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import SwiftUI

struct AddContactView<ViewModel: ContactViewModelProtocol>: View {
    @FocusState private var focusedField: FocusedFiedls?
    @ObservedObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        if vm.isloadingImage {
                               SkeletonView()
                                   .frame(width: 240, height: 240)
                                   .transition(.opacity)
                        } else {
                            AsyncImage(url: URL(string: vm.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    placeholder
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    placeholder
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 240, height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            
                        }
                        Button(Constants.load_image) {
                            Task { await vm.loadImage() }
                        }
                        
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()
                        .background()
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        
                        customField(title: Constants.name, text: $vm.name)
                            .focused($focusedField, equals: .name)
                        divider
                        customField(title: Constants.lastName, text: $vm.lastName)
                            .focused($focusedField, equals: .lastName)
                        divider
                        customField(title: Constants.phone, text: $vm.phone)
                            .focused($focusedField, equals: .phone)
                            .keyboardType(.numberPad)
                            .onChange(of: vm.phone) { _, newValue in
                                vm.phone = PhoneValidator.validatePhoneInput(newValue)
                            }
                        
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            
            
            
            Button {
                vm.save()
                
                if vm.isValid {
                    dismiss()
                }
            } label: {
                if vm.isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text(Constants.save)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(vm.isValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            .disabled(!vm.isValid || vm.isSaving || vm.isloadingImage)
            
        }
        .onAppear(perform: {
            Task { await vm.loadImage() }
            
        })
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
        .navigationTitle(Constants.new_contact)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text(Constants.cancel)
                }
                
            }
        }
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
            
            Image(systemName: Constants.photo_placeholder)
                .font(.system(size: 30))
                .foregroundColor(.gray)
        }
    }
    
    func customField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: text)
                .font(.body)
        }
        .padding()
    }
    
    var divider: some View {
        Divider()
            .padding(.leading)
    }

}


#Preview {
    let storage = ContactStorage()
    let repo = ContactRepository(storage: storage)
    let imageService = ImageService()
    let vm = ContactViewModel(repository: repo,
                              imageService: imageService)
    AddContactView(vm: vm)
}


enum FocusedFiedls: Equatable {
    case name, lastName, phone
}

//
//  MainMessagesView.swift
//  Chat-Firebase-SwiftUI
//
//  Created by Cengizhan Tomak on 31.10.2023.
//

import SwiftUI

struct MainMessagesView: View {
    @State var shouldShowLogOutOptions = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
//                Text("User: \(vm.chatUser?.uid ?? "")")
                customNavBar
                Divider()
                messagesView
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: vm.chatUser?.profileImageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipped()
            .cornerRadius(50)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 44)
                    .stroke(.primary, lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 4) {
                let email = vm.chatUser?.email.components(separatedBy: "@").first ?? ""
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundStyle(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 44)
                                    .stroke(.primary, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
            .padding(.top, 16)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.vertical)
            .background(.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
    }
}

#Preview {
    MainMessagesView()
//        .preferredColorScheme(.dark)
}

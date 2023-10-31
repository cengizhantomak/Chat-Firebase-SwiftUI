//
//  LoginView.swift
//  Chat-Firebase-SwiftUI
//
//  Created by Cengizhan Tomak on 31.10.2023.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}

struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker Here")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(.white)
                    
                    Button {
                        handleAction()
                    }label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundStyle(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Acoount")
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
//            print("Should log into Firebase with existing credentials")
        } else {
            createNewAccount()
//            print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to Login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
}

#Preview {
    LoginView()
}

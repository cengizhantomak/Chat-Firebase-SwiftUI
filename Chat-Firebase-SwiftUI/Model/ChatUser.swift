//
//  ChatUser.swift
//  Chat-Firebase-SwiftUI
//
//  Created by Cengizhan Tomak on 3.11.2023.
//

import Foundation

struct ChatUser {
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

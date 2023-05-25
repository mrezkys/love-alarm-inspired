//
//  UserModel.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//

import Foundation
import AuthenticationServices
import CloudKit
struct UserModel: Codable{
    let userId: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    var target: String = ""
    var lovedBy: [String] = [""]
   
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.target = ""
    }
    
    init() {
        self.userId = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.target = ""
    }
    
    init?(record: CKRecord) {
        guard
            let userId = record["userId"] as? String,
            let firstName = record["firstName"] as? String,
            let lastName = record["lastName"] as? String,
            let email = record["email"] as? String,
            let lovedBy = record["lovedBy"] as? [String],
                let target = record["target"] as? String
        else { return nil }
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.lovedBy = lovedBy
        self.target = target
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId ?? "",
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "email": email ?? "",
            "lovedBy" : lovedBy,
            "target" : target
        ]
    }
}

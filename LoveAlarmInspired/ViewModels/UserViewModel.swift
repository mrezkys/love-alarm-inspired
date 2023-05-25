//
//  UserViewModel.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//

import Foundation
import CloudKit
import AuthenticationServices

enum RecordType: String {
    case userModel = "userModel"
}

enum  ViewState {
    case loading
    case loaded
    case error
    case empty
}

class UserViewModel: ObservableObject{
    private var key: String = "userModel"
    private var database: CKDatabase = CKContainer(identifier: "iCloud.LoveAlarmInspired").publicCloudDatabase
    @Published var userModel: UserModel? = nil
    @Published var viewState: ViewState = ViewState.empty
    @Published var userTarget: UserModel? = nil
    
    init()  {
        self.userModel = getUserFromUserDefaults()
//        self.userTarget = await getUserByEmail(self.userModel?.email ?? "")
    }
    
   
    func refresh() async {
        
        let newUserModel = await getUserFromCloudKit()
        if (newUserModel != nil){
            userModel = newUserModel
        }
        let newUserTarget = await getUserByEmail(userTarget?.email ?? "")
        print(newUserModel, "newUserTarget")
        if(newUserTarget != nil){
            userTarget = newUserTarget
        }
        print("REFRESHED-------------------")
    }
    
    func getUserFromCloudKit() async -> UserModel? {
        guard let email = userModel?.email else {
            return nil
        }
        
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: NSPredicate(format: "email == %@", email))
        do {
            let records = try await self.database.perform(query, inZoneWith: nil)
            if let record = records.first {
                print("record ", record)
                UserDefaults.standard.setValue(try JSONEncoder().encode(UserModel(record: record)), forKey: key)

                return UserModel(record: record)
            }
        } catch {
            print("An error occurred: \(error)")
        }
        return nil
    }
    
    func updateUserTarget(_ target: String) async {
        guard let email = userModel?.email else {
            return
        }
        
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            if let record = records.first {
                record["target"] = target
                
                do {
                    try await database.save(record)
                    
                } catch {
                    print("Failed to update user: \(error)")
                }
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }

    
    func updateUserLovedBy(_ email: String) async {
        print("aaa", email)
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            if let record = records.first {
                var lovedBy = record["lovedBy"] as? [String] ?? []
                if !lovedBy.contains(userModel?.email ?? "") {
                    lovedBy.append(userModel?.email ?? "")
                    record["lovedBy"] = lovedBy
                    print(lovedBy, "lovedby")
                    
                    do {
                        try await database.save(record)
                    } catch {
                        print("Failed to update user: \(error)")
                    }
                }
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }

    
    func getUserByEmail(_ email: String) async -> UserModel? {
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            if let record = records.first {
                return UserModel(record: record)
            } else {
                return nil
            }
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

    
    func getAllUser() async -> [UserModel] {
        //get all user except myself using email
        
        let email = userModel!.email!
//        return list of userModel
        let predicate = NSPredicate(format: "email != %@", email)
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: predicate)
        
        do {
            let records = try await database.perform(query, inZoneWith: nil)
            let users = records.compactMap { record in
                UserModel(record: record)
            }
            print(users)
            return users
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
    
    func getUserFromUserDefaults() -> UserModel? {
        if let userData = UserDefaults.standard.value(forKey: key) as? Data {
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: userData)
                return user
            } catch {
                print("Failed to decode user data: \(error)")
            }
        }
        return nil
    }
    
    func register(_ userModel: UserModel) async {
        if(userModel.email != nil){
            let isUserExist =  await isUserExistInCloudKit(email: userModel.email ?? "")
            if(!isUserExist){
                let record = CKRecord(recordType: RecordType.userModel.rawValue)
                record.setValuesForKeys(userModel.toDictionary())
                do {
                    try await database.save(record)
                    UserDefaults.standard.setValue(try JSONEncoder().encode(userModel), forKey: key)
                    self.userModel = userModel
                } catch{
                    print(error)
                }
                
            }
        }
    }
    
    private func isUserExistInCloudKit(email: String) async -> Bool {
        let query = CKQuery(recordType: RecordType.userModel.rawValue, predicate: NSPredicate(format: "email == %@", email))
        
        do{
            let record = try await database.perform(query, inZoneWith: nil)
            if record.isEmpty{
                return false
            } else {
                return true
            }
        } catch{
            print(error)
            return true
        }
    }
}

//
//  CoreDataManager.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 16.12.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    
    func createUser(fullName: String, birthDay: Date, isMale: Bool, ava: String)
    
    func readUsers() -> [User]
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String)
    
    func deleteUser(user: User)
    
}

final class CoreDataManager:  CoreDataManagerProtocol {
    
    private let persistentService = PersistentService()
    lazy var context: NSManagedObjectContext = persistentService.context
    
    func createUser(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        let newUser = User(context: context)
        newUser.id = getNextId()
        newUser.fullName = fullName
        newUser.birthDay = birthDay
        newUser.isMale = isMale
        newUser.ava = ava
        persistentService.saveContext()

    }
    
    func readUsers() -> [User]{
        let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
        
        var users = [User]()
        
        users = try! context.fetch(fetchRequest)
        return users
    }
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String) {
        
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "id = %@", String(user.id))
        let results = try? context.fetch(fetchUser)
        if results?.count != 0 {
            // here you are updating
            let cdUser = results?.first
            cdUser?.fullName = newFullName
            cdUser?.birthDay = newBirthDay
            cdUser?.isMale = newIsMale
        }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        context.delete(user)
    }
    
    func clearUsers() {
        let fetchRequest = User.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    func createDefualtValues() {
        let existinctUsers = readUsers()
        if (existinctUsers.filter({$0.id == 1}).count == 0) {
            createUser(fullName: "Dart Vader", birthDay: Date.now, isMale: true, ava: "DV")
        }
        
        if (existinctUsers.filter({$0.id == 2}).count == 0) {
            createUser(fullName: "Luke Skywalker", birthDay: Date.now, isMale: true, ava: "LS")
        }
        
        if (existinctUsers.filter({$0.id == 3}).count == 0) {
            createUser(fullName: "Padme Amidala", birthDay: Date.now, isMale: false, ava: "PA")
        }
    }
    
    private func getNextId() -> Int16 {
        return (readUsers().last?.id ?? 0) + 1
    }
    
    func saveContext() {
        persistentService.saveContext()
    }
}

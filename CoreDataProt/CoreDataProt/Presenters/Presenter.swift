//
//  Presenter.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 03.01.2024.
//

import Foundation

protocol ViewOutputDelegate: AnyObject {
    func getData()
    func saveData()
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String)
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String)
    func deleteUser(user: User, indexPath: IndexPath)
    func clearUsers()
}

final class Presenter {
    
    weak private var viewInputDelegate: ViewInputDelegate?
    private var coreDataManager = CoreDataManager()
    var users = [User]()
    
    func setViewinputDelegate(viewinputDelegate: ViewInputDelegate) {
        self.viewInputDelegate = viewinputDelegate
    }
    
    func createDefaultData() {
        coreDataManager.createDefualtValues()
    }
    
    func getDataFromCD() {
        self.users = coreDataManager.readUsers()
        self.viewInputDelegate?.setupData(data: self.users)
    }
    
    func saveDataToCD() {
        coreDataManager.saveContext()
    }
    
    func addUserToCD(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        coreDataManager.createUser(fullName: fullName, birthDay: birthDay, isMale: isMale, ava: ava)
    }
    
    func deleteUserFromCD(user: User, indexPath: IndexPath) {
        coreDataManager.deleteUser(user: user)
        self.viewInputDelegate?.deleteData(indexPath: indexPath)
    }
    
    func clearUsersFromCD() {
        coreDataManager.clearUsers()
    }
    
    func updateUserInCD(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String) {
        coreDataManager.updateUser(user: user, newFullName: newFullName, newBirthDay: newBirthDay, newIsMale: newIsMale, newAva: newAva)
    }
    
}

extension Presenter: ViewOutputDelegate {
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String) {
        self.updateUserInCD(user: user, newFullName: newFullName, newBirthDay: newBirthDay, newIsMale: newIsMale, newAva: newAva)
    }
    
    func getData() {
        self.createDefaultData()
        self.getDataFromCD()
    }
    
    func saveData() {
        self.saveDataToCD()
        self.getDataFromCD()
    }
    
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        self.addUserToCD(fullName: fullName, birthDay: birthDay, isMale: isMale, ava: ava)
        self.getDataFromCD()
    }
    
    func deleteUser(user: User, indexPath: IndexPath) {
        self.deleteUserFromCD(user: user, indexPath: indexPath)
    }
    
    func clearUsers() {
        self.clearUsersFromCD()
        self.getDataFromCD()
    }
}

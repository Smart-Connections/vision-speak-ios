//
//  DataSourceProto.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import RealmSwift
import Foundation

protocol DataSource {
    associatedtype Target: Object
    var realm: Realm { get }
    func getAll() -> [Target]
    func add(_ data: [Target])
    func update(_ data: Target)
    func delete(_ data: Target)
}

extension DataSource {
    func getAll() -> [Target] {
        printResult("getAll", data: Target.self)
        return realm.objects(Target.self).map({$0})
    }
    
    func add(_ data: [Target]) {
        try! realm.write {
            data.forEach { target in
                realm.add(target, update: .error)
            }
        }
        printResult("add", data: data)
    }
    
    func update(_ data: Target) {
        try! realm.write {
            realm.add(data, update: .modified)
        }
        printResult("update", data: data)
    }
    
    func delete(_ data: Target) {
        try! realm.write {
            realm.delete(data)
        }
        printResult("delete", data: data)
    }
    
    private func printResult(_ funcName: String, data: Any) {
        debugPrint("Realm DataSource: \(type(of: self)): \(funcName) \(data)")
    }
}

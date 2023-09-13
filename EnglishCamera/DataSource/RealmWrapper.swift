//
//  RealmWrapper.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import RealmSwift
import Foundation

class RealmWrapper {

    private static var realmPerThread: Dictionary < String, Realm > = [:]

    private init() { }

    static func sharedInstance() throws -> Realm {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 2) {
                migration.enumerateObjects(ofType: Vocabulary.className()) { oldObject, newObject in
                }
            }
        })
        Realm.Configuration.defaultConfiguration = config
        var realm = self.realmPerThread[self.threadId()]
        if realm == nil {
            do {
                realm = try Realm()
                self.realmPerThread[threadId()] = realm
            }  catch {
                debugPrint("Realm init error: unexpected")
            }
        }
        return realm!
    }

    static func destroy() {
        self.realmPerThread.removeValue(forKey: self.threadId())
    }

    private static func threadId() -> String {
        let id = Thread.current.name ?? ""
        debugPrint("threadId: \(id)")
        return id
    }
}

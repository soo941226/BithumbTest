//
//  CDManager.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/01.
//

import CoreData

final class CDManager {
    static let errorNotification = Notification.Name("CDManagerError")
    static let shared = CDManager()
    let container = NSPersistentContainer(name: "Main")
    let context: NSManagedObjectContext

    private init() {
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                NotificationCenter.default.post(
                    name: CDManager.errorNotification,
                    object: nil,
                    userInfo: ["error": error]
                )
            }
        }
        context = container.newBackgroundContext()
    }

    func retrieve<Model: NSManagedObject>() -> [Model]? {
        let request = Model.fetchRequest()

        do {
            return try context.fetch(request) as? [Model]
        } catch {
            sendNotification(with: error)
            return nil
        }
    }

}

// MARK: - Error handling
private extension CDManager {
    func sendNotification(with error: Error) {
        NotificationCenter.default.post(
            name: CDManager.errorNotification,
            object: nil,
            userInfo: ["error": error]
        )
    }
}

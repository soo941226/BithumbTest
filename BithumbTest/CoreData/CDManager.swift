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

    private let container = NSPersistentContainer(name: "Main")
    private let context: NSManagedObjectContext

    func retrieve<Model: NSManagedObject>(with filter: NSPredicate? = nil) -> [Model]? {
        let request = Model.fetchRequest()

        if let filter = filter {
            request.predicate = filter
        }

        do {
            return try context.fetch(request) as? [Model]
        } catch {
            sendNotification(with: error)
            return nil
        }
    }

    func insert<Model: NSManagedObject>(
        model: Model.Type,
        with setter: (NSManagedObject) -> Void
    ) {
        let model = NSManagedObject(entity: Model.entity(), insertInto: context)
        setter(model)
        tryToSaveContext()
    }

    func insertModels<Model: NSManagedObject>(
        _ model: Model.Type,
        amount: Int,
        with setter: ([NSManagedObject]) -> Void
    ) {
        var models = [NSManagedObject]()
        for _ in 0..<amount {
            models.append(NSManagedObject(entity: Model.entity(), insertInto: context))
        }
        setter(models)
        tryToSaveContext()
    }

    func deleteAll<Model: NSManagedObject>(
        model: Model.Type,
        filter: NSPredicate? = nil
    ) {
        if let models: [Model] = retrieve(with: filter) {
            models.forEach { model in
                context.delete(model)
            }

            tryToSaveContext()
        }
    }

    private func tryToSaveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            sendNotification(with: error)
        }
    }

    private func sendNotification(with error: Error) {
        NotificationCenter.default.post(
            name: CDManager.errorNotification,
            object: nil,
            userInfo: ["error": error]
        )
    }

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
}

//
//  SwiftDataManagerFunctions.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

public func SwiftDataInitialize(config: SwiftDataConfiguration) {
    SwiftDataManager.initialize(config: config)
}

public func SDExecuteFetchRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> AnyObject? {
    return SwiftDataManager.sharedManager.executeFetchRequest(fetchRequest: fetchRequest)
}

public func SDSaveManagedObjectContext() {
    return SwiftDataManager.sharedManager.saveManagedObjectContext()
}

public func SDDeleteObject(object: NSManagedObject) {
    SwiftDataManager.sharedManager.deleteObject(object: object);
}

public func SDManagedObjectContext() -> NSManagedObjectContext {
    return SwiftDataManager.sharedManager.managedObjectContext
}

public func SDRegisterBackgroundContext() -> NSManagedObjectContext {
    return SwiftDataManager.sharedManager.registerBackgroundContext()
}

public func SDSaveManagedObjectContext(context: NSManagedObjectContext) {
    return SwiftDataManager.sharedManager.saveBackgroundContext(ctx: context)
}

public func SDSaveManagedObjectContextAndWait(context: NSManagedObjectContext) {
    return SwiftDataManager.sharedManager.saveBackgroundContextAndWait(ctx: context)
}

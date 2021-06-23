    //
//  SwiftDataManager+NSManagedObjectContext.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation
import CoreData

extension SwiftDataManager {
    
    //MARK: - NSManagedObjectContext
    
    func executeFetchRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> AnyObject? {
        
        do {
            
            let results = try self.managedObjectContext.fetch(fetchRequest)
            return results as AnyObject?
        
        } catch let e as NSError {
            self.logError(method: "executeFetchRequest", message: "\(e)")
            return nil
        }
    }
    
    func saveManagedObjectContext() {
        
        if self.managedObjectContext.hasChanges {
            
            self.managedObjectContext.perform({
                
                do {
                    try self.managedObjectContext.save()
                    
                } catch let e as NSError {
                    self.logError(method: "saveManagedObjectContext - Failed to save main context with error: ", message: "\(e)")
                    return
                }
                
                self.backgroundWriterContext.perform({
                    
                    do {
                        try self.backgroundWriterContext.save()
                        
                    } catch let e as NSError {
                        self.logError(method: "saveManagedObjectContext - Failed to save background writer context with error: ", message: "\(e)")
                        return
                    }
                })
            })
        }
    }
    
    func saveManagedObjectContextAndWait() {
        
        if self.managedObjectContext.hasChanges {
            
            self.managedObjectContext.performAndWait({
                
                do {
                    try self.managedObjectContext.save()
                    
                } catch let e as NSError {
                    self.logError(method: "saveManagedObjectContext - Failed to save main context with error: ", message: "\(e)")
                    return
                }
                
                self.backgroundWriterContext.perform({
                    
                    do {
                        try self.backgroundWriterContext.save()
                        
                    } catch let e as NSError {
                        self.logError(method: "saveManagedObjectContext - Failed to save background writer context with error: ", message: "\(e)")
                        return
                    }
                })
            })
        }
    }
    
    func saveBackgroundContext(ctx: NSManagedObjectContext) {
        
        if ctx.hasChanges {
            
            ctx.perform({
                
                do {
                    try ctx.save()
                } catch {
                    self.logError(method: "saveBackgroundContext", message: "Error saving background context")
                }
                
                
                self.saveManagedObjectContext()
            })
        }
    }
    
    func saveBackgroundContextAndWait(ctx: NSManagedObjectContext) {
        
        if ctx.hasChanges {
            
            ctx.performAndWait({
                
                do {
                    try ctx.save()
                } catch {
                    self.logError(method: "saveBackgroundContext", message: "Error saving background context")
                }
                
                
                self.saveManagedObjectContextAndWait()
            })
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
}

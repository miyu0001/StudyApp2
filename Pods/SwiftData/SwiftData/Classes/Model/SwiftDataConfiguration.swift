//
//  SwiftDataConfiguration.swift
//  SwiftData
//
//  Created by Mike Neill on 10/26/15.
//  Copyright © 2015 Mike's App Shop. All rights reserved.
//

import Foundation

public class SwiftDataConfiguration {
    
    public var databaseFileName: String
    public var appGroupName: String?
    
    public required init(databaseFileName: String) {
        self.databaseFileName = databaseFileName
    }
}

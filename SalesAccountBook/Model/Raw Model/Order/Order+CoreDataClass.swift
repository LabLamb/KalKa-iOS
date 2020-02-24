//
//  Order+CoreDataClass.swift
//  
//
//  Created by LabLamb on 23/2/2020.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    override var id: String {
        get {
            return String(self.number)
        }
    }
}

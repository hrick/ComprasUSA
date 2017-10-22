//
//  UIViewController+CoreData.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}


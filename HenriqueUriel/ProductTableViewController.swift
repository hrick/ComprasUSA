//
//  ProductTableViewController.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        label.textColor = .black
        
        loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductRegisterViewController {
            if tableView.indexPathForSelectedRow != nil {
                vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
    }
    
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let count = fetchedResultController.fetchedObjects?.count {
                tableView.backgroundView = (count == 0) ? label : nil
                return count
            } else {
                tableView.backgroundView = label
                return 0
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.lbName.text = product.name
        if product.state != nil {
            cell.lbState.text = product.state!.name
        }
        cell.lbValue.text = "\(product.value)"
        if let image = product.picture as? UIImage {
            cell.ivPicture.image = image
        } else {
            cell.ivPicture.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            context.delete(product)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}













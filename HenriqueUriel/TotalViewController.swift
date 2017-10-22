//
//  TotalViewController.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var lbTotalUs: UILabel!
    @IBOutlet weak var lbTotalRs: UILabel!
    var products: [Product] = []
    var cotacaoDolar: Double!
    var iof: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iof = Double(UserDefaults.standard.string(forKey: "iof")!)!
        cotacaoDolar = Double(UserDefaults.standard.string(forKey: "cotacao_dolar")!)!
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(fetchRequest)
            populateFields()
        } catch {
            print(error.localizedDescription)
        }
    }

    func populateFields() {
        if products.count > 0 {
            var totalUS = 0.0
            var totalRS = 0.0
            for product in products {
                totalUS += product.value
                let valueStateTax = product.value * (product.state!.tax / 100)
                let valueReal = (product.value + valueStateTax) * cotacaoDolar
                if product.paymentCard {
                    totalRS += (valueReal * (iof / 100)) + valueReal
                } else {
                    totalRS += valueReal
                }
            }
            lbTotalUs.text = "\(totalUS)"
            lbTotalRs.text = "\(totalRS)"
        } else {
            lbTotalUs.text = "0.0"
            lbTotalRs.text = "0.0"
        }
    }
        
}

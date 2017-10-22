//
//  SettingsViewController.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit
import CoreData

enum StateType {
    case add
    case edit
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfCotacaoDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tbStates: UITableView!
    
    var states: [State] = []
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbStates.delegate = self
        tbStates.dataSource = self
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        label.textColor = .black
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfIOF.text = UserDefaults.standard.string(forKey: "iof")
        tfCotacaoDolar.text = UserDefaults.standard.string(forKey: "cotacao_dolar")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(tfIOF.text!, forKey: "iof")
        UserDefaults.standard.set(tfCotacaoDolar.text!, forKey: "cotacao_dolar")
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
            tbStates.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func resgiterState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
    
    func showAlert(type: StateType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double(alert.textFields![1].text!)!
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let category = self.states[indexPath.row]
            self.context.delete(category)
            try! self.context.save()
            self.states.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.states[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        self.showAlert(type: .edit, state: state)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (states.count == 0) ? label : nil
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! SettingsTableViewCell
        let state = states[indexPath.row]
        cell.lbTax.text = "\(state.tax)"
        cell.lbNameState.text = state.name
        cell.accessoryType = .none
        return cell
    }
}



















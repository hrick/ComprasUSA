//
//  ProductRegisterViewController.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swPaymentCard: UISwitch!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var btRegisterEdit: UIButton!
    
    var pickerView: UIPickerView!
    
    var smallImage: UIImage!
    var product: Product!
    var stateSelected: State!
    var states: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            stateSelected = product.state
            tfName.text = product.name
            tfValue.text = "\(product.value)"
            btRegisterEdit.setTitle("Atualizar", for: .normal)
            if let image = product.picture as? UIImage {
                ivPicture.image = image
            }
            swPaymentCard.setOn(product.paymentCard, animated: false)
        }
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfState.inputView = pickerView
        
        tfState.inputAccessoryView = toolbar
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }
    
    @objc func done() {
        tfState.text = states[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStates()
        if product != nil {
            if product.state != nil {
                tfState.text = product.state!.name
            }
        }
    }
    
    @IBAction func registerEditProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        if tfName.text!.isEmpty {
            self.alert(msg: "Nome do produto")
        } else if tfState.text!.isEmpty || stateSelected == nil {
            self.alert(msg: "Estado da compra")
        } else if tfValue.text!.isEmpty {
            self.alert(msg: "Valor")
        } else if smallImage == nil && product.picture == nil {
            self.alert(msg: "Foto")
        } else {
            product.name = tfName.text!
            product.value = Double(tfValue.text!)!
            product.paymentCard = swPaymentCard.isOn
            if smallImage != nil {
                product.picture = smallImage
            }
            product.state = stateSelected
            do {
                try context.save()
                close()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func close () {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func alert(msg: String){
        let alert = UIAlertController(title: "Dados obrigatorios", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addPicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 288, height: 128)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPicture.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}
extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        stateSelected = states[row]
        return states[row].name
    }
}

extension ProductRegisterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
}



















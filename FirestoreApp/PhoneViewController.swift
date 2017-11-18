//
//  PhoneViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 MEspinasso. All rights reserved.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {
    
    @IBOutlet weak var tfModel: UITextField!
    @IBOutlet weak var tfManufacturer: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfYear: UITextField!
    
    lazy var firestore: Firestore = {
        let store = Firestore.firestore()
        return store
    }()
    
    var phone: Phone!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if phone != nil {
            tfModel.text = phone.model
            tfManufacturer.text = phone.manufacturer
            tfPrice.text = "\(phone.price)"
            tfYear.text = "\(phone.year)"
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        var phoneDict: [String: Any] = [:]
        phoneDict["model"] = tfModel.text!
        phoneDict["manufacturer"] = tfManufacturer.text!
        phoneDict["price"] = Double(tfPrice.text!)!
        phoneDict["year"] = Int(tfYear.text!)!
        
        if phone == nil {
            firestore.collection("phones").addDocument(data: phoneDict) { (error: Error?) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            firestore.collection("phones").document(phone.id).setData(phoneDict, completion: { (error: Error?) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

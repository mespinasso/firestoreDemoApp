//
//  PhonesTableViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 MEspinasso. All rights reserved.
//

import UIKit
import Firebase

class PhonesTableViewController: UITableViewController {
    
    var phones: [Phone] = []
    
    lazy var firestore: Firestore = {
        let store = Firestore.firestore()
        return store
    }()
    
    var firestoreListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firestoreListener = firestore.collection("phones").order(by: "model", descending: false).addSnapshotListener({ (snapshot: QuerySnapshot?, error: Error?) in
            
            if error == nil {
                guard let snapshot = snapshot else { return }
                
                self.phones.removeAll()
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let model = data["model"] as! String
                    let manufacturer = data["manufacturer"] as! String
                    
//                    print(data["price"].debugDescription)
//                    print(data["year"].debugDescription)
                    
                    let price = data["price"] as! Double
                    let year = data["year"] as! Int
                    let id = document.documentID
                    
                    let phone = Phone(id: id, model: model, manufacturer: manufacturer, price: price, year: year)
                    self.phones.append(phone)
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phone = sender as? Phone {
            let vc = segue.destination as! PhoneViewController
            vc.phone = phone
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let phone = phones[indexPath.row]
        cell.textLabel?.text = phone.model
        cell.detailTextLabel?.text = phone.manufacturer

        return cell
    }

    
    // Managing Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let phone = phones[indexPath.row]
            firestore.collection("phones").document(phone.id).delete()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phone = phones[indexPath.row]
        performSegue(withIdentifier: "editSegue", sender: phone)
    }

}

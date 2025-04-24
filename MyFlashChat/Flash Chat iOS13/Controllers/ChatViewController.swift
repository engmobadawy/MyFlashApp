//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    var messages: [MessageModel] = []

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        tableView.dataSource = self
        
        
        
        let nib = UINib(nibName: "MyCellTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "myCellIdentifier")
        
        fetchMessages()

    }


    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let mymessage = messageTextfield.text, !mymessage.isEmpty {
            if let currentUser = Auth.auth().currentUser, let senderEmail = currentUser.email {
                let db = Firestore.firestore()
                let messageData: [String: Any] = [
                    "text": mymessage,
                    "senderEmail": senderEmail,
                    "timestamp": Timestamp(date: Date())
                ]
                
                db.collection("messages").addDocument(data: messageData) { error in
                    if let error = error {
                        print("Error sending message: \(error)")
                    } else {
                        print("Message sent!")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                        
                    }
                }
            }
            
        }
    }

    

    func fetchMessages() {
        let db = Firestore.firestore()

        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }

                if let documents = snapshot?.documents {
                    var fetchedMessages: [MessageModel] = []

                    for doc in documents {
                        let data = doc.data()
                        if let text = data["text"] as? String,
                           let senderEmail = data["senderEmail"] as? String {
                            let message = MessageModel(sender: senderEmail, message: text)
                            fetchedMessages.append(message)
                        }
                    }

                    self.messages = fetchedMessages

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let lastRow = self.messages.count - 1
                        if lastRow >= 0 {
                            let indexPath = IndexPath(row: lastRow, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                    }
                } else {
                    print("No documents")
                }
            }
    }


  




    
    
    @IBAction func PressedLogOut(_ sender: UIBarButtonItem) {
     do {
                try Auth.auth().signOut()
                navigationController?.popToRootViewController(animated: true)
                print("Log Out succsessfully ")
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
   
    

    

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count // Or your data count
    }


        
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCellIdentifier", for: indexPath) as? MyCellTableViewCell {
            // Set up your cell
            
            cell.youAvatar.isHidden = true
            cell.meAvatar.isHidden = true

            if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
                cell.meAvatar.isHidden = false
                cell.messageBubble.backgroundColor = UIColor(named: "BrandLightPurple")
                cell.actualMessage.textColor = UIColor(named: "BrandPurple")
            } else {
                cell.youAvatar.isHidden = false
                cell.messageBubble.backgroundColor = UIColor(named: "BrandPurple")
                cell.actualMessage.textColor = UIColor(named: "BrandLightPurple")
            }

            cell.actualMessage.text = messages[indexPath.row].message
        
            return cell
        } else {
            return UITableViewCell()
        }
    }

    
    


    
}



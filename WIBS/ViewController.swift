//
//  ViewController.swift
//  WIBS
//
//  Created by Team-Uno on 1/18/18.
//  Copyright © 2018 Team-Uno. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    
    var list = [Player]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        button.layer.cornerRadius = 5
        fetchAll()
        print (list)
        for player in list{
            print (player.name!)
        }
        
        playerName.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ nameTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @objc func keyBoardWillShow(sender: NSNotification){
        self.view.frame.origin.y -= 200
    }
    @objc func keyBoardWillHide(sender: NSNotification){
        self.view.frame.origin.y += 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].name!
        
        return cell
    }
    
    func fetchAll(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Player")
        do{
            let result = try managedObjectContext.fetch(request)
            list = result as! [Player]
        }catch{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print (sender!)
        if sender is UIButton{
            
            let player = playerName.text

            let destination = segue.destination as! GameViewController
            destination.playerName = player
        }
        else if sender is NSIndexPath {
            // code here for selecting player from existing players list
            let temp = sender as AnyObject
            let destination = segue.destination as! GameViewController
            let player = String(describing: list[temp.row].name)
            
            destination.playerName = player
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "gameSegue", sender: indexPath)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        // code to insert new player into db and into list
        let item = NSEntityDescription.insertNewObject(forEntityName: "Player", into: managedObjectContext) as! Player
        item.name = playerName.text
        
        do {
            try managedObjectContext.save()
            print ("saved data")
        }catch{
            print(error)
        }
        tableView.reloadData()
        playerName.text = ""
        performSegue(withIdentifier: "gameSegue", sender: self)
        
    }
    // IBAction for unwind segue from resultVC
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        
    }
    
    

}


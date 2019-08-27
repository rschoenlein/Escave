//
//  HuntTableViewController.swift
//  Escave
//
//  Created by Ryan Schoenlein on 5/21/19.
//  Copyright © 2019 Ryan Schoenlein. All rights reserved.
//

import UIKit
import os.log
import MapKit

class HuntTableViewController: UITableViewController {
    
    //MARK: Properties
    
    //empty array hunts is property of HuntTableViewController class
    var hunts = [Hunt]()
    
    //MARK: Actions
    
    //updates UITableView gui object and hunts array
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EscaveViewController, let hunt = sourceViewController.hunt {
            
            //update existing hunt or add a new hunt
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                hunts[selectedIndexPath.row] = hunt
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: hunts.count, section: 0)
                
                hunts.append(hunt)
                
                //insert gui object into UITableView
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the hunts.
            saveHunts()
        }
    }

    
    //MARK: Private Methods
    
    private func loadSampleHunts() {
        //load image
        let photo1 = UIImage(named: "hunt1")
       
        
        //create hunt object with image
        //Because the Hunt class’s init!(name:, photo:, rating:) initializer is failable, check for error
        guard let hunt1 = Hunt(name: "Placeholder Hunt Item", photo: photo1, rating: 4, lat: 38.925560, long: -9.229723) else {
            fatalError("Unable to instantiate hunt1")
        }
        
        hunts += [hunt1]
    }
    
    //save hunts to file path defined in Hunt.swift
    private func saveHunts() {

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(hunts, toFile: Hunt.ArchiveURL.path)
       
        if isSuccessfulSave {
            os_log("Hunts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save hunts...", log: OSLog.default, type: .error)
        }
    }
    
    
    //called on loading of tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.leftBarButtonItem = editButtonItem
       
        navigationItem.leftItemsSupplementBackButton = true
        
        
        
        // Load any saved hunts, otherwise load sample data.
        if let savedHunts = loadHunts() {
            hunts += savedHunts
        }
        else {
            // Load the sample data.
            loadSampleHunts()
        }
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //set number of rows in UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }

    //set the type of cell in UITableVew as HuntTableViewCell(defined in HuntTableViewCell.swift) and configure cell properties
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HuntTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HuntTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HuntTableViewCell.")
        }
        
        // Fetches the appropriate hunt for the data source layout.
        let huntl = hunts[indexPath.row]

        //configure cell properties
        cell.nameLabel.text = huntl.name
        cell.photoImageView.image = huntl.photo
        cell.ratingControl.rating = huntl.rating

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Allow cells in the table view to be deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {

                hunts.remove(at: indexPath.row)
                
                saveHunts()
                
                //updates GUI
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        //call inherited class (Of typeController)'s prepare func
        super.prepare(for: segue, sender: sender)
        
        //look at seque identifier
        //If the identifier is nil, the nil-coalescing operator (??) replaces it with an empty string ("").
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new hunt.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let huntDetailViewController = segue.destination as? EscaveViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedHuntCell = sender as? HuntTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedHuntCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedHunt = hunts[indexPath.row]
                huntDetailViewController.hunt = selectedHunt
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }
    
    //attempts to unarchive object stored at Hunt.ArchiveURL.path
    private func loadHunts() -> [Hunt]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Hunt.ArchiveURL.path) as? [Hunt]
    }
}

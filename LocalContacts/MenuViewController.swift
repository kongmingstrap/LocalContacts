//
//  MenuViewController.swift
//  LocalContacts
//
//  Created by Takaaki Tanaka on 2015/10/03.
//  Copyright © 2015年 Takaaki Tanaka. All rights reserved.
//

import UIKit
import ContactsUI

class MenuViewController: UITableViewController, CNContactPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let showContactButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showContact:")
        self.navigationItem.rightBarButtonItem = showContactButton
        
    }

    func showContact(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            
            let contactPickerViewController = CNContactPickerViewController()
            contactPickerViewController.delegate = self
            self.presentViewController(contactPickerViewController, animated: true, completion: nil)
            
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        print("contactPickerDidCancel")
    }
    
    /*!
    * @abstract Singular delegate methods.
    * @discussion These delegate methods will be invoked when the user selects a single contact or property.
    */
    @available(iOS 9.0, *)
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        print("didSelectContact \(contact)")
    }
    
    @available(iOS 9.0, *)
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        print("didSelectContactProperty \(contactProperty)")
    }
    
    /*!
    * @abstract Plural delegate methods.
    * @discussion These delegate methods will be invoked when the user is done selecting multiple contacts or properties.
    * Implementing one of these methods will configure the picker for multi-selection.
    */
    @available(iOS 9.0, *)
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        print("didSelectContacts \(contacts)")
    }
    
    @available(iOS 9.0, *)
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
        print("didSelectContactProperties \(contactProperties)")
    }

}

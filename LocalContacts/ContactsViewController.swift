//
//  ContactsViewController.swift
//  LocalContacts
//
//  Created by Takaaki Tanaka on 2015/10/03.
//  Copyright © 2015年 Takaaki Tanaka. All rights reserved.
//

import UIKit
//import AddressBookManager

import Contacts

class ContactsViewController: UITableViewController {

    //var addressBookManager: AddressBookManager? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if #available(iOS 9.0, *) {
            {
                
                let contact = CNMutableContact()
            
                contact.givenName = "John"
                contact.familyName = "Appleseed"
            
                
                let mainNumber = CNLabeledValue(label:CNLabelPhoneNumberMain, value:"012-345-6789")
                let iPhoneNumber = CNLabeledValue(label:CNLabelPhoneNumberiPhone, value:"111-222-3333")
                contact.phoneNumbers = [mainNumber, iPhoneNumber]
                
                
                
                let store = CNContactStore()
                
                
                let saveRequest = CNSaveRequest()
                
                saveRequest.addContact(contact, toContainerWithIdentifier:nil)
                do {
                    try store.executeSaveRequest(saveRequest)
                } catch {
                    abort()
                }
                
            }
            
            {
                let identifier = "035218FA-1E6E-4D1C-9708-76FBC0E55F28"
                
                
                let store = CNContactStore()
                
                let contact = try store.unifiedContactWithIdentifier(identifier, keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
                
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                
                let newEmail = CNLabeledValue(label: CNLabelHome, value: "johnny@example.com")
                mutableContact.emailAddresses.append(newEmail)
                
                let saveRequest = CNSaveRequest()
                
                saveRequest.updateContact(mutableContact)
                
                do {
                    try store.executeSaveRequest(saveRequest)
                } catch {
                    abort()
                }
                
                
                    
            
            }
            
            {
                let identifier = "035218FA-1E6E-4D1C-9708-76FBC0E55F28"
                
                let groupPredicate = CNGroup.predicateForGroupsWithIdentifiers([identifier])
                
                
                
                let store = CNContactStore()
                //let group = try store.
            }
            
            
            
            
            {
                
                let identifier = "035218FA-1E6E-4D1C-9708-76FBC0E55F28"
                
                let store = CNContactStore()
                
                let contact = try store.unifiedContactWithIdentifier(identifier, keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
                
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                
                let saveRequest = CNSaveRequest()
                saveRequest.deleteContact(mutableContact)

                do {
                    try store.executeSaveRequest(saveRequest)
                } catch {
                    abort()
                }
            }
            
            
            
            
            
            let store = CNContactStore()
            
            do {
                let predicate = CNContact.predicateForContactsMatchingName("Appleseed")
                
                let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch:[CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                    CNContactPhoneNumbersKey])
                
                //let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactNamePrefixKey,  CNContactMiddleNameKey, CNContactNameSuffixKey,  CNContactPhoneNumbersKey])
                
                let contact = contacts.first
                
                print("\(contact!.identifier) \(contact!.givenName) \(contact!.familyName) \(contact!.phoneNumbers)")
                
                
                let keysToFetch = [
                
                    CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                    CNContactPhoneNumbersKey]
                let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch:keysToFetch)
                
                
                
                let contact = contacts.first
                
                print("\(contact!.identifier) \(contact!.givenName) \(contact!.familyName) \(contact!.phoneNumbers)")
                
                
                // Checking if phone number is available for the given contact.
                
                
                if contact!.isKeyAvailable(CNContactPhoneNumbersKey) {
                    
                    
                    print("CNContactFamilyNameKey: \(contact!.identifier) \(contact!.givenName) \(contact!.familyName)")
                } else {
                    //Refetch the keys
                    //let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
                    
                    
                    //let refetchedContact = try store.unifiedContactWithIdentifier(contact!.identifier, keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey])
                    
                    
                    let refetchedContact = try store.unifiedContactWithIdentifier("035218FA-1E6E-4D1C-9708-76FBC0E55F28", keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
                    
                    
                    print("Refetch: \(refetchedContact.identifier) \(refetchedContact.givenName) \(refetchedContact.familyName)")
                }
            } catch {
                abort()
            }
                
                
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

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

}

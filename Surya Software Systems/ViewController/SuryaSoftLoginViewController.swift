//
//  SuryaSoftLoginViewController.swift
//  Surya Software Systems
//
//  Created by Raghavendra Dattawad on 11/22/18.
//  Copyright © 2018 Raghavendra Dattawad. All rights reserved.
//

import UIKit
import CoreData


// instructions on how to build and run your code.

//// Download the project from github
/// open workspace
/// Go to Similator and select any simulator start building.
/// onece build is completed it will run the project


class SuryaSoftLoginViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    defaultDisplay()
   
    }
    func defaultDisplay(){
        
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1
    
    }

    @IBAction func signInAction(_ sender: Any) {

        
        /// sign in flow checking // with email id //
        if self.emailField.text!.isEmpty{

       alertForEmailValidtion(alertShowMessage: " Enter a  Email Address")
        
        }
        let email = self.isValidEmail(testStr: self.emailField.text!)
        print(email)
        if email == false {
        
        alertForEmailValidtion(alertShowMessage: "Please Enter a Valid Emaild Address")
        }
        else {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "email = %@",self.emailField.text!)

        let results: NSArray  = try! managedObjectContext.fetch(request) as NSArray
        print("results user ",results)

        if(results.count > 0){
            let res = results[0] as! NSManagedObject
            print(res,"one obj")
         let getEmailId = res.value(forKey: "email") as! String
           print(getEmailId)

         self.performSegue(withIdentifier: "userDetails", sender: self)
         }
        
        else {

     let dict :[String:String] = ["emailId":self.emailField.text!]

        ServiceManager.sharedInstance.postValues(urlRequest:URLs.base_Url , postData: dict) { (data, error) -> (Void) in
         guard let data = data else { return }
          do {
    let decoder = JSONDecoder()
    ServiceManager.sharedInstance.itemOfUserDetails = try decoder.decode(UserDetails.self ,from: data)
        
            DispatchQueue.main.async {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       let managedObjectContext = appDelegate.persistentContainer.viewContext
       guard let entity = NSEntityDescription.entity(forEntityName:"User", in: managedObjectContext) else { return }
       let newUser = NSManagedObject(entity: entity, insertInto: managedObjectContext)
       newUser.setValue(self.emailField.text, forKey: "email")
             do {
                   try managedObjectContext.save()

                } catch let error as NSError {
                   print("Couldn't save. \(error)")
                }
               print(newUser)
               print("Object Saved.")
            }
         DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "userDetails", sender: self)
            }
          } catch let jsonError {
            print(jsonError)
            self.alertForEmailValidtion(alertShowMessage: "Something Went Wrong")
            }
            }
            self.performSegue(withIdentifier: "userDetails", sender: self)
//self.alertForEmailValidtion(alertShowMessage: "Something Went Wrong")
        }
    }

    }
    func isValidEmail(testStr:String) -> Bool {

    print("validate emilId: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
        
      
    }
    func alertForEmailValidtion(alertShowMessage:String){

    let refreshAlert = UIAlertController(title: "Alert!!!", message:alertShowMessage, preferredStyle: UIAlertController.Style.alert)

    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in

    }))
    self.present(refreshAlert, animated: true, completion: nil)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}



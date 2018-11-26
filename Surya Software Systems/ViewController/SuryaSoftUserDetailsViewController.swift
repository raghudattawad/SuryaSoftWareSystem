//
//  SuryaSoftUserDetailsViewController.swift
//  Surya Software Systems
//
//  Created by Raghavendra Dattawad on 11/24/18.
//  Copyright © 2018 Raghavendra Dattawad. All rights reserved.
//

import UIKit

class SuryaSoftUserDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        if let path = Bundle.main.path(forResource: "UserDataDetails", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                ServiceManager.sharedInstance.itemOfUserDetails = try decoder.decode(UserDetails.self ,from: data)
                
            } catch {
                
        self.alertForEmailValidtion(alertShowMessage: "Some thing went wrong")
            }
        }
        
    }

    func alertForEmailValidtion(alertShowMessage:String){
        
        let refreshAlert = UIAlertController(title: "Alert!!!", message:alertShowMessage, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
    }

}
///// tableivew reload the details//
extension SuryaSoftUserDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ServiceManager.sharedInstance.itemOfUserDetails?.items?.count)!
        
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
        let detailscell = tableView.dequeueReusableCell(withIdentifier: "userDetails", for: indexPath) as! UserDetailsCell
    
    detailscell.firstNameDisplay.text = ServiceManager.sharedInstance.itemOfUserDetails?.items?[indexPath.row].firstName
     detailscell.lastNameDisplay.text = ServiceManager.sharedInstance.itemOfUserDetails?.items?[indexPath.row].lastName
     detailscell.emaiIIdDisplay.text = ServiceManager.sharedInstance.itemOfUserDetails?.items?[indexPath.row].emailId
    
    let urlString = ServiceManager.sharedInstance.itemOfUserDetails?.items?[indexPath.row].imageUrl
    print(urlString!)
   
    let task = URLSession.shared.dataTask(with: URL(string: urlString!)!) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            
            detailscell.imageViewDisplay.image = UIImage(data: data)
            detailscell.imageViewDisplay.layer.borderWidth=1.0
           detailscell.imageViewDisplay.layer.masksToBounds = false
            detailscell.imageViewDisplay.layer.borderColor = UIColor.white.cgColor
            detailscell.imageViewDisplay.layer.cornerRadius =  detailscell.imageViewDisplay.frame.size.height/2
             detailscell.imageViewDisplay.clipsToBounds = true
         
        }
    }
    task.resume()
    
    return detailscell
    
    }
    
}
class UserDetailsCell: UITableViewCell {
    
    @IBOutlet weak var emaiIIdDisplay: UILabel!
    @IBOutlet weak var lastNameDisplay: UILabel!
    @IBOutlet weak var firstNameDisplay: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!

}

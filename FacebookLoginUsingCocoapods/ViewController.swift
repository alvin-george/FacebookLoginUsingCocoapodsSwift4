//
//  ViewController.swift
//  FacebookLoginUsingCocoapods

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var loginStatus: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    @IBOutlet var profilePictureImageURL: UILabel!
    @IBOutlet var facebookProfilePicture: FBSDKProfilePictureView!
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    var fbDetails : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate =  self
        verifyInitialAccessToFacebook()
    }
    override func viewWillAppear(_ animated: Bool) {
        profilePictureImageURL.sizeToFit()
        profilePictureImageURL.layoutIfNeeded()
        
    }
    func verifyInitialAccessToFacebook(){
        
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        
        let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFacebookUserData()
                        loginManager.logOut()
                    }
                }
            }
        }
    }
    func getFacebookUserData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.fbDetails = result as? NSDictionary
                    // print(self.fbDetails!)
                    
                    self.usernameLabel.text = self.fbDetails?.object(forKey: "name") as! String?
                    self.passwordLabel.text = self.fbDetails?.object(forKey: "email") as! String?
                    
                    let profilePictureDict =  self.fbDetails?.object(forKey: "picture") as? NSDictionary
                    let profilePictureDataDict =  profilePictureDict?.object(forKey: "data") as? NSDictionary
                    print("pictDataArray  :\(profilePictureDataDict )")
                    self.profilePictureImageURL.text = "Image URL : "+(profilePictureDataDict?.object(forKey: "url") as! String?)!
                    
                }else{
                    print(error?.localizedDescription ?? "Not found")
                }
            })
        }
    }
    
    //FBSDKLoginButtonDelegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.loginStatus.text =  "logged out"
        self.usernameLabel.text = ""
        self.passwordLabel.text = ""
        self.profilePictureImageURL.text = ""
        
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        self.loginStatus.text =  "logged in"
        return true
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getFacebookUserData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}


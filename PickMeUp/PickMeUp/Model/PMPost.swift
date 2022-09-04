//
//  PMPost.swift
//  PickMeUp
//
//  Created by Abigail Shilts on 9/2/22.
//

import UIKit
import FirebaseFirestore
import Parse
import GeoFire
import FirebaseStorage

@objc class PMPost: NSObject {
    var bio: NSString
    var sport: NSString
    var intensity: NSString
    var groupWhere: NSString
    var groupWhen: NSString
    var isEvent: NSString
    var longitude: Double
    var latitude: Double
    var author: PFUser
    
    @objc override init(){
        self.bio = ""
        self.sport = ""
        self.intensity = ""
        self.groupWhere = ""
        self.groupWhen = ""
        self.isEvent = ""
        self.longitude = 0.0
        self.latitude = 0.0
        self.author = PFUser.current()!
    }
    
    @objc func update(bio: NSString, chosenSport: NSString, intensity: NSString, wheree: NSString, when: NSString, event: NSString, longi: Double, lati: Double) {
        self.bio = bio
        self.sport = chosenSport
        self.intensity = intensity
        self.groupWhere = wheree
        self.groupWhen = when
        self.isEvent = event
        self.longitude = longi
        self.latitude = lati
    }
    
    @objc func savePost(imagee: UIImage){
        // stores image
        guard imagee != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = imagee.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let fileName = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(fileName)
        fileRef.putData(imageData!, metadata:nil){
            metadata, error in
            if error == nil && metadata != nil {
                print("all good")
            }
            else {
                print(error)
            }
        }
        
        // gets location set up
        let location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let hash = GFUtils.geoHash(forLocation: location)
        var ref: DocumentReference? = nil
        
        // saves to database
        ref = Firestore.firestore().collection("users").addDocument(data: [
            "bio": self.bio,
            "sport": self.sport,
            "intensity": self.intensity,
            "groupWhere": self.groupWhere,
            "groupWhen": self.groupWhen,
            "isEvent": self.isEvent,
            "longitude": self.longitude,
            "latitude":self.latitude,
            "author": self.author.objectId,
            "geohash": hash,
            "img": fileName,
            "created": Timestamp.init()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}

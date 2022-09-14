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

@objcMembers class PMPost: NSObject {
    var ident: NSString
    var bio: NSString
    var sport: NSString
    var intensity: NSString
    var groupWhere: NSString
    var groupWhen: NSString
    var isEvent: NSString
    var authID: NSString
    var longitude: Double
    var latitude: Double
    var author: PFUser
    var img: UIImage
    var storageRef: StorageReference
    
    @objc override init(){
        self.ident = ""
        self.bio = ""
        self.sport = ""
        self.intensity = ""
        self.groupWhere = ""
        self.groupWhen = ""
        self.isEvent = ""
        self.authID = ""
        self.longitude = 0.0
        self.latitude = 0.0
        self.author = PFUser.current()!
        self.img = UIImage()
        self.storageRef = Storage.storage().reference()
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
    
    @objc static func saveImage(imagee: UIImage, userID: NSString, completion: @escaping (NSURL) -> Void){
        let storageRef = Storage.storage().reference()
        let imageData = imagee.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let fileName = "user/\(userID).jpg"
        let fileRef = storageRef.child(fileName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        fileRef.putData(imageData!, metadata:metaData){
            metaData, error in
            if error != nil {
                print(error)
            }
            fileRef.downloadURL { (url, error) in
                if error != nil {
                    print(error)
                }
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                completion(downloadURL as NSURL)
              }
        }
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
        ref = Firestore.firestore().collection("posts").addDocument(data: [
            "id":UUID().uuidString,
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
    
    @objc static func makePost(doc: DocumentSnapshot) -> PMPost {
        let toReturn = PMPost()
        toReturn.ident = doc.get("id") as! NSString
        toReturn.bio = doc.get("bio") as! NSString
        toReturn.sport = doc.get("sport") as! NSString
        toReturn.groupWhen = doc.get("groupWhen") as! NSString
        toReturn.groupWhere = doc.get("groupWhere") as! NSString
        toReturn.intensity = doc.get("intensity") as! NSString
        toReturn.isEvent = doc.get("isEvent") as! NSString
        toReturn.authID = doc.get("author") as! NSString
        toReturn.longitude = doc.get("longitude") as! Double
        toReturn.latitude = doc.get("latitude") as! Double
        toReturn.storageRef = Storage.storage().reference(withPath: doc.get("img") as! String)
        return toReturn
    }
    
    @objc func addAuth(use:PFUser) {
        self.author = use
    }

    @objc static func getPosts(selectedSport:NSString, selectedIntensity:NSString, loc:CLLocation, dist:NSString, finished: @escaping (NSArray) -> Void){
        let db = Firestore.firestore()
        let center = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude:loc.coordinate.longitude)
        let radiusInM = 1609.34 * (dist as NSString).doubleValue
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("posts")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        var matchingDocs = [QueryDocumentSnapshot]()
        
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }

            for document in documents {
                let lat = document.data()["latitude"] as? Double ?? 0
                let lng = document.data()["longitude"] as? Double ?? 0
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)

                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                if distance <= radiusInM {
                    matchingDocs.append(document)
                }
            }
            
            if qCount == queries.count {
                var arr = NSMutableArray()
                for doc in matchingDocs {
                    if (selectedSport == doc.data()["sport"] as! NSObject || selectedSport == "Any") && (selectedIntensity == doc.data()["intensity"] as! NSObject || selectedIntensity == "any") {
                        arr.add(self.makePost(doc: doc))
                    }
                }
                finished(arr)
            }
        }
        var qCount = 0
        for query in queries {
            qCount += 1
            query.getDocuments(completion: getDocumentsCompletion)
        }
    }
}

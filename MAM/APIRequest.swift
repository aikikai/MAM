//
//  APIRequest.swift
//  MurAndMarti
//
//  Created by Luciano Wehrli on 15/1/16.
//  Copyright © 2016 Ramotion. All rights reserved.
//

import Foundation
import Parse
import Bolts

class APIRequest{

    static func getAllObjects(className className: String, completion:(Array<PFObject>) -> Void){
        let query = PFQuery(className: className)
        query.findObjectsInBackgroundWithBlock({ (obj, ErrorType) -> Void in
            if let arrPF = obj{
                completion(arrPF)
            }
        })
    }
    
    static func saveObject(ofertaObj: oferta, className: String, completion:(Array<oferta>)->Void){
        let ObjPF = PFObject(className: className)
        ObjPF["title"] = ofertaObj.title
        ObjPF["description"] = ofertaObj.description
        ObjPF["category"] = ofertaObj.category
        ObjPF["publishing_date"] = ofertaObj.publishing_date
        ObjPF["due_date"] = ofertaObj.due_date
        ObjPF["company_project"] = ofertaObj.company_project
        ObjPF["address"] = ofertaObj.address
        
        ObjPF.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object Saved")
            self.getAllObjects(className: className, completion: { (arrObj) -> Void in
                var arrayOfertas = Array<oferta>()
                for var ofertaItem in arrObj{
                    var objectId = ""
                    if let id = ofertaItem.objectId{
                        objectId = id
                    }
                    let title : String = { guard let temp = ofertaItem["title"] as? String else { return "" }; return temp }()
                    let description : String = { guard let temp = ofertaItem["description"] as? String else { return "" }; return temp }()
                    let category : String = { guard let temp = ofertaItem["category"] as? String else { return "" }; return temp }()
                    let company_project : String = { guard let temp = ofertaItem["company_project"] as? String else { return "" }; return temp }()
                    let address : String = { guard let temp = ofertaItem["address"] as? String else { return "" }; return temp }()
                    let publishing_date : String = { guard let temp = ofertaItem["publishing_date"] as? String else { return "" }; return temp }()
                    let due_date : String = { guard let temp = ofertaItem["due_date"] as? String else { return "" }; return temp }()
                    let of = oferta(objectId: objectId ,title: title, description: description, category: category, company_project: company_project, address: address, publishing_date: publishing_date, due_date: due_date)
                    arrayOfertas.append(of)
                }
                completion(arrayOfertas)
            })
        }
    }

    static func updateObject(ofertaObj: oferta, className: String, completion:(Array<oferta>)->Void){
        let ObjPF = PFObject(className: className)
        if let id = ofertaObj.objectId{
            ObjPF.objectId = id
        }
        ObjPF["title"] = ofertaObj.title
        ObjPF["description"] = ofertaObj.description
        ObjPF["category"] = ofertaObj.category
        ObjPF["publishing_date"] = ofertaObj.publishing_date
        ObjPF["due_date"] = ofertaObj.due_date
        ObjPF["company_project"] = ofertaObj.company_project
        ObjPF["address"] = ofertaObj.address
        ObjPF.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object Updated")
            self.getAllObjects(className: className, completion: { (arrObj) -> Void in
                var arrayOfertas = Array<oferta>()
                for var ofertaItem in arrObj{
                    var objectId = ""
                    if let id = ofertaItem.objectId{
                        objectId = id
                    }
                    let of = oferta(objectId: objectId, title: ofertaItem["title"] as! String, description: ofertaItem["description"] as! String, category: ofertaItem["category"] as! String, company_project: ofertaItem["company_project"] as! String, address: ofertaItem["address"] as! String, publishing_date: ofertaItem["publishing_date"] as! String, due_date: ofertaItem["due_date"] as! String)
                    arrayOfertas.append(of)
                }
                completion(arrayOfertas)
            })            
        }
    }

}
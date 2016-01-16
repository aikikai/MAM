//
//  oferta.swift
//  MurAndMarti
//
//  Created by Luciano Wehrli on 15/1/16.
//  Copyright © 2016 Ramotion. All rights reserved.
//

import Foundation
import Parse
import Bolts

class oferta{
    var objectId : String?
    var title : String?
    var description : String?
    var category : String?
    var company_project : String?
    var address : String?
    var publishing_date : String?
    var due_date : String?
    
    init(objectId: String, title: String, description: String, category: String, company_project: String, address: String, publishing_date: String, due_date: String){
        self.objectId = objectId
        self.title = title
        self.description = description
        self.category = category
        self.company_project = company_project
        self.publishing_date = publishing_date
        self.due_date = due_date
        self.address = address
    }

    init(title: String, description: String, category: String, company_project: String, address: String, publishing_date: String, due_date: String){
        self.title = title
        self.description = description
        self.category = category
        self.company_project = company_project
        self.publishing_date = publishing_date
        self.due_date = due_date
        self.address = address
    }
    
    init(){
        
    }
    
}
//
//  ViewController.swift
//  MurAndMarti
//
//  Created by LUCIANO WEHRLI on 15/01/2016.
//  Copyright (c) 2014 . All rights reserved.
//

import UIKit
import Parse
import Bolts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index :NSInteger = 0
    var offerArray = Array<oferta>()
    let empty = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2-70, UIScreen.mainScreen().bounds.size.width, 60))

    override func viewWillAppear(animated: Bool) {
        if let updated = NSUserDefaults.standardUserDefaults().objectForKey("updatedOffer") as? String{
            if updated == "true"{ // se actualizó alguna oferta y hay que hacer request
                NSUserDefaults.standardUserDefaults().removeObjectForKey("updatedOffer")
                request()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyles()
        tableView.delegate = self
        tableView.alpha = 0.0
        request()
    }

    func request(){
        offerArray.removeAll()
        APIRequest.getAllObjects(className: OFERTA){ (result) in
            if result.isEmpty{
                self.empty.text = "No hay ofertas disponibles. \nCrea la primera!"
                self.empty.textAlignment = .Center
                self.empty.numberOfLines = 0
                self.empty.font = UIFont(name: "HelveticaNeue-Light", size: 16)
                self.empty.tintColor = UIColor.RGBColor(red: 180, green: 180, blue: 200)
                self.empty.tag = 999
                self.view.addSubview(self.empty)
            }
            else{
                for var ofertaItem in result{
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
                    self.offerArray.append(of)
                }
                self.tableView.reloadData()
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.empty.removeFromSuperview()
                    self.tableView.alpha = 1.0
                })
                
            }
        }
    }
    
    //MARK: TABLEVIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ofertaCellIdentifier", forIndexPath: indexPath) as! OfertaTableViewCell
        
        let currentOffer = offerArray[indexPath.row]
        cell.title.text = currentOffer.title!
        cell.category.text = "Categoría: \(CATEGORIES[Int(currentOffer.category!)!])"
        cell.dates.text = "\(convertDate(currentOffer.publishing_date!)) - \(convertDate(currentOffer.due_date!))"
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: STYLES
    func setStyles(){
        self.navigationItem.hidesBackButton = false
        self.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.RGBColor(red: 10, green: 103, blue: 183)
        self.navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 19)!]
        self.title = "Ofertas"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsIdentifier"{
            let detailsVC = segue.destinationViewController as! DetailsViewController
            let index = tableView.indexPathForSelectedRow
            if let ind = index?.row{
                detailsVC.ofertaActual = offerArray[ind]
            }
        }
        
        if segue.identifier == "AddIdentifier"{
        
        }
    }
    
    func convertDate(date: String) -> String{
        //2016-01-16 12:30
        let ar = date.componentsSeparatedByString(" ")
        let dateOnly = ar[0].componentsSeparatedByString("-")
        let orderedDate = "\(dateOnly[2])-\(dateOnly[1])-\(dateOnly[0])"
        return "\(orderedDate)"        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


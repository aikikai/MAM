//
//  AddViewController.swift
//  MurAndMarti
//
//  Created by Luciano Wehrli on 15/1/16.
//  Copyright © 2016 Luciano Wehrli. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var scrollContentSize : CGFloat!{
        didSet{
            self.scrollView.contentSize = CGSize(width: maxWidth, height: scrollContentSize)
        }
    }
    
    var ofertaNueva : oferta!
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let marginLeft : CGFloat = 20
    let maxWidth = UIScreen.mainScreen().bounds.size.width - 20
    let marginTop : CGFloat = 5
    
    var inputTitle : UITextField!
    var category : UIPickerView!
    var inputDescription : UITextField!
    var inputProject : UITextField!
    var datePublishing : UIDatePicker!
    var dateDue : UIDatePicker!
    var inputAddress : UITextField!
    var okButton : UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ofertaNueva = oferta()
        scrollContentSize = 10
        setStyles()
        scrollView.delegate = self
        setFormComponents()
    }
    
    func setFormComponents(){
        self.scrollView.addSubview(labelFactory("Título de la oferta"))
        inputTitle = inputFactory()
        self.scrollView.addSubview(inputTitle)
        
        self.scrollView.addSubview(labelFactory("Descripcion"))
        inputDescription = inputFactory(textArea: true)
        self.scrollView.addSubview(inputDescription)
        
        self.scrollView.addSubview(labelFactory("Proyecto/Empresa"))
        inputProject = inputFactory()
        self.scrollView.addSubview(inputProject)
        
        self.scrollView.addSubview(labelFactory("Direccion"))
        inputAddress = inputFactory()
        self.scrollView.addSubview(inputAddress)
        
        self.scrollView.addSubview(labelFactory("Publicacion"))
        datePublishing = datePickerFactory()
        datePublishing.setDate(NSDate(), animated: true)
        self.scrollView.addSubview(datePublishing)
        
        self.scrollView.addSubview(labelFactory("Vencimiento"))
        dateDue = datePickerFactory()
        datePublishing.setDate(NSDate(), animated: true)
        self.scrollView.addSubview(dateDue)
        
        self.scrollView.addSubview(labelFactory("Categoria"))
        category = pickerFactory()
        category.selectRow(0, inComponent: 0, animated: true)
        self.scrollView.addSubview(category)        
        
        okButton = UIButton(frame: CGRectMake(marginLeft, scrollContentSize+marginTop*5, maxWidth-marginLeft, 40))
        scrollContentSize = scrollContentSize + (okButton.frame.origin.y-scrollContentSize) + okButton.frame.size.height + marginTop*10
        okButton.setTitle("CREAR OFERTA", forState: UIControlState.Normal)
        okButton.backgroundColor = UIColor.RGBColor(red: 10, green: 71, blue: 158)
        okButton.enabled = true
        okButton.addTarget(self, action: Selector("saveOffer"), forControlEvents: UIControlEvents.TouchDown)
        self.scrollView.addSubview(okButton)
    }
    
    
    func labelFactory(texto: String) -> UILabel{
        let label = UILabel(frame: CGRectMake(marginLeft, scrollContentSize+marginTop, maxWidth-marginLeft, 30))
        label.text = texto
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        scrollContentSize = scrollContentSize + (label.frame.origin.y-scrollContentSize) + label.frame.size.height
        return label
    }
    
    
    func inputFactory(textArea textArea: Bool = false) -> UITextField{
        var alto : CGFloat = 30.0
        if textArea{ alto = 80.0}
        let input = UITextField(frame: CGRectMake(marginLeft, scrollContentSize, maxWidth-marginLeft, alto))
        input.backgroundColor = UIColor.whiteColor()
        input.borderStyle = UITextBorderStyle.RoundedRect
        input.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        input.userInteractionEnabled = true
        scrollContentSize = scrollContentSize + (input.frame.origin.y-scrollContentSize) + input.frame.size.height
        return input
    }
    
    
    func datePickerFactory() -> UIDatePicker{
        let date = UIDatePicker(frame: CGRectMake(marginLeft, scrollContentSize-marginTop, maxWidth-marginLeft, 120))
        date.datePickerMode = UIDatePickerMode.Date
        date.userInteractionEnabled = true
        scrollContentSize = scrollContentSize + (date.frame.origin.y-scrollContentSize) + date.frame.size.height
        return date
    }
    
    func pickerFactory() -> UIPickerView{
        let picker = UIPickerView(frame: CGRectMake(marginLeft, scrollContentSize-marginTop*5, maxWidth-marginLeft, 120))
        scrollContentSize = scrollContentSize + (picker.frame.origin.y-scrollContentSize) + picker.frame.size.height
        picker.delegate = self
        picker.userInteractionEnabled = true
        picker.dataSource = self
        return picker
    }
    
    //MARK: PICKERVIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CATEGORIES.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return CATEGORIES[row]
    }
    
    
    //MARK: STYLES
    func setStyles(){
        self.view.backgroundColor = UIColor.RGBColor(red: 240, green: 240, blue: 240)
    }
    
    
    func saveOffer(){
        ofertaNueva.title = inputTitle.text!
        ofertaNueva.description = inputDescription.text!
        ofertaNueva.company_project = inputProject.text!
        ofertaNueva.address = inputAddress.text!
        ofertaNueva.publishing_date = formatDate(datePublishing.date)
        ofertaNueva.due_date = formatDate(dateDue.date)
        ofertaNueva.category = String(category.selectedRowInComponent(0))
        
        APIRequest.saveObject(ofertaNueva, className: OFERTA) { (result) -> Void in
            let alerta = UIAlertController(title: "Felicitaciones", message: "Creaste una nueva oferta", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
                self.dismiss(self)
            }))
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        NSUserDefaults.standardUserDefaults().setObject("true", forKey: "updatedOffer")
    }
    
    
    func formatDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

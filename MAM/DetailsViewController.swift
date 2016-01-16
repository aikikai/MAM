//
//  DetailsViewController.swift
//  MurAndMarti
//
//  Created by Luciano Wehrli on 15/1/16.
//  Copyright © 2016 Luciano Wehrli. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var scrollContentSize : CGFloat!{
        didSet{
            self.scrollView.contentSize = CGSize(width: maxWidth, height: scrollContentSize)
        }
    }
    
    var ofertaActual : oferta!
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
        scrollContentSize = 10
        setStyles()
        scrollView.delegate = self
        setFormComponents()
    }

    @IBAction func editOffer(sender: AnyObject) {
        toggleFormEditing("enable")
    }
    
    func setFormComponents(){
        self.scrollView.addSubview(labelFactory("Título de la oferta"))
        inputTitle = inputFactory()
        inputTitle.text = ofertaActual.title
        self.scrollView.addSubview(inputTitle)

        self.scrollView.addSubview(labelFactory("Descripcion"))
        inputDescription = inputFactory(textArea: true)
        inputDescription.text = ofertaActual.description
        self.scrollView.addSubview(inputDescription)

        self.scrollView.addSubview(labelFactory("Proyecto/Empresa"))
        inputProject = inputFactory()
        inputProject.text = ofertaActual.company_project
        self.scrollView.addSubview(inputProject)

        self.scrollView.addSubview(labelFactory("Direccion"))
        inputAddress = inputFactory()
        inputAddress.text = ofertaActual.address
        self.scrollView.addSubview(inputAddress)

        self.scrollView.addSubview(labelFactory("Publicacion"))
        datePublishing = datePickerFactory()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:ss"
        var date = dateFormatter.dateFromString(ofertaActual.publishing_date!)
        datePublishing.setDate(date!, animated: true)
        self.scrollView.addSubview(datePublishing)
        
        self.scrollView.addSubview(labelFactory("Vencimiento"))
        dateDue = datePickerFactory()
        date = dateFormatter.dateFromString(ofertaActual.due_date!)
        datePublishing.setDate(date!, animated: true)
        self.scrollView.addSubview(dateDue)
        
        self.scrollView.addSubview(labelFactory("Categoria"))
        category = pickerFactory()
        let pickerIndex = Int(ofertaActual.category!)!
        category.selectRow(pickerIndex, inComponent: 0, animated: true)
        self.scrollView.addSubview(category)
        
        
        okButton = UIButton(frame: CGRectMake(marginLeft, scrollContentSize+marginTop*5, maxWidth-marginLeft, 40))
        scrollContentSize = scrollContentSize + (okButton.frame.origin.y-scrollContentSize) + okButton.frame.size.height + marginTop*10
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.backgroundColor = UIColor.RGBColor(red: 10, green: 71, blue: 158)
        toggleButtonState(okButton, state: "disable")
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
        input.backgroundColor = UIColor.RGBColor(red: 220, green: 220, blue: 220)
        input.userInteractionEnabled = false
        scrollContentSize = scrollContentSize + (input.frame.origin.y-scrollContentSize) + input.frame.size.height
        return input
    }
    
    
    func toggleOKButton(){
        okButton.enabled = !okButton.enabled
        okButton.alpha = okButton.enabled ? 1.0 : 0.3
    }
    
    func datePickerFactory() -> UIDatePicker{
        let date = UIDatePicker(frame: CGRectMake(marginLeft, scrollContentSize-marginTop, maxWidth-marginLeft, 120))
        date.datePickerMode = UIDatePickerMode.Date
        date.userInteractionEnabled = false
        scrollContentSize = scrollContentSize + (date.frame.origin.y-scrollContentSize) + date.frame.size.height
        return date
    }

    func pickerFactory() -> UIPickerView{
        let picker = UIPickerView(frame: CGRectMake(marginLeft, scrollContentSize-marginTop*5, maxWidth-marginLeft, 120))
        scrollContentSize = scrollContentSize + (picker.frame.origin.y-scrollContentSize) + picker.frame.size.height
        picker.delegate = self
        picker.userInteractionEnabled = false
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
        self.navigationItem.hidesBackButton = false
        self.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.RGBColor(red: 10, green: 103, blue: 183)
        self.navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 19)!]
        self.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.RGBColor(red: 240, green: 240, blue: 240)
        
    }

    
    func toggleFormEditing(flag: String = ""){
        for var v in scrollView.subviews{
            if flag == "disable"{
                v.userInteractionEnabled = false
                if v.isKindOfClass(UITextField){
                    v.backgroundColor = UIColor.RGBColor(red: 220, green: 220, blue: 220)
                }else if v.isKindOfClass(UIButton){
                    toggleButtonState(v as! UIButton, state: "disable")
                }

            }else
                if flag == "enable"{
                    v.userInteractionEnabled = true
                    if v.isKindOfClass(UITextField){
                        v.backgroundColor = UIColor.whiteColor()
                    }else if v.isKindOfClass(UIButton){
                        toggleButtonState(v as! UIButton, state: "enable")
                    }
                    
                }else{
                    v.userInteractionEnabled = !v.userInteractionEnabled //toggle
                    v.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    func toggleButtonState(okButton: UIButton, state: String){
        if state == "disable"{
        okButton.enabled = false
        okButton.alpha = 0.3
        }else{
            okButton.enabled = true
            okButton.alpha = 1.0
        }
    }
    
    
    func saveOffer(){
        ofertaActual.title = inputTitle.text!
        ofertaActual.description = inputDescription.text!
        ofertaActual.company_project = inputProject.text!
        ofertaActual.address = inputAddress.text!
        ofertaActual.publishing_date = formatDate(datePublishing.date)
        ofertaActual.due_date = formatDate(dateDue.date)
        ofertaActual.category = String(category.selectedRowInComponent(0))
        
        APIRequest.updateObject(ofertaActual, className: OFERTA) { (result) -> Void in
            let alerta = UIAlertController(title: "Oferta", message: "Actualización exitosa", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
                self.toggleFormEditing("disable")
                self.navigationController?.popViewControllerAnimated(true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

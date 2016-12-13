//
//  AddNotesViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 13/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class AddNotesViewController: UIViewController {
    @IBOutlet weak var notesTextView: UITextView!
    fileprivate var placholderText = "Add your notes"
    fileprivate let COMMENTS_LIMIT = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        //notesTextView.text = workdictHolder?.userNotes
        if (notesTextView.text == "") {
            textViewDidEndEditing(notesTextView)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddNotesViewController.cancelPressed(_:)))
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(AddNotesViewController.saveAction(_:)))
        
//        if workdictHolder?.jobStatus == JobStatus.CompleteStatus.rawValue{
//            navigationItem.rightBarButtonItem = nil
//            notesTextView.isEditable = false
//            if  notesTextView.text == placholderText{
//                notesTextView.text = "No notes saved"
//                
//            }
//            
//        }
//        else {
            navigationItem.rightBarButtonItem = saveButton
            notesTextView.isEditable = true
        //}
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 104/255, green: 168/255, blue: 220/25, alpha: 1)

        // Do any additional setup after loading the view.
    }

    
    func cancelPressed(_:UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func saveAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if notesTextView.text.isBlank || notesTextView.text == placholderText {
            showAlert("Please enter some note")
        }
        else {
            
        }
    }
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    
    func showLoader(){
        AlertView.sharedInstance.setLabelText("Saving notes")
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            self.dismiss(animated: true, completion: nil)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNotesViewController:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = placholderText
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == placholderText){
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    
    func textView(_ textView: UITextView,  shouldChangeTextIn range:NSRange, replacementText text:String ) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= COMMENTS_LIMIT;
    }
}

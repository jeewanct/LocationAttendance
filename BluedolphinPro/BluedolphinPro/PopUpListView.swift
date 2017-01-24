//
//  PopUpListView.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 16/01/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//
enum SortEnum:String{
    case StartDateAsc
    case StartDateDes
    case EndDateAsc
    case EndDateDes
    case ClearSort
}
import UIKit


protocol ListSelection:class {
    func cellSelected(value:SortEnum)
}

class PopUpListView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var contentView: PopUpListView!

    weak var delegate: ListSelection!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sortListView: UITableView!
    var selectableIndexPath:IndexPath =  IndexPath(row: 0, section: 0)
    var view: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    let nibName = "PopUpListView"
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        /// Adds a shadow to our view
        view.layer.cornerRadius = 4.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        
    }
    
    func loadViewFromNib() ->UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }    
    
    let items = ["Start Date (Asc)","Start Date (Des)","End Date (Asc)","End Date (Dsc)","Clear Sort"]
    
    
    func displayView() {
        createListView()
        self.alpha = 0.0
        self.isHidden = false
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(
            withDuration:0.3 * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options:.allowUserInteraction,
            animations: {
                self.alpha = 1.0
                
        }, completion: nil
            
        )
    }
    
  
    
    func hideMenu() {
        // Rotate arrow
        UIView.animate(
            withDuration: 0.3 * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options:.allowUserInteraction,
            animations: {
               
        }, completion: nil
        )
        
        // Animation
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                
                self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
   
    func createListView(){
        self.sortListView.delegate = self
        self.sortListView.dataSource = self
        
        
        //        self.separatorEffect = UIBlurEffect(style: .Light)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        sortListView.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        blurView.addGestureRecognizer(tapGesture)
        
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        hideMenu()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath == selectableIndexPath{
            cell.textLabel!.textColor = APPCOLOR.baseColor

        }else{
            cell.textLabel!.textColor = UIColor.gray
 
        }
        cell.textLabel!.font =  UIFont(name: "SourceSansPro-Regular", size: 17)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectableIndexPath = indexPath
        if let delegate = self.delegate {
            switch indexPath.row {
            case 0:
                delegate.cellSelected(value: .StartDateAsc)
            case 1:
                delegate.cellSelected(value: .StartDateDes)
            case 2:
                delegate.cellSelected(value: .EndDateAsc)

            case 3:
                delegate.cellSelected(value: .EndDateDes)

            case 4:
                
                delegate.cellSelected(value: .ClearSort)
            default:
                break
            }
        }
        hideMenu()

    }
    
   

}

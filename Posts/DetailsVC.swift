import UIKit
import CoreData

class DetailsVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var excerptLbl: UILabel!
    @IBOutlet weak var closeView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImgView: UIImageView!
    var partiPost = [String:Any]()
    
    @IBOutlet weak var readPostBtn: UIButton!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        designInit()
        
        let titleDict = partiPost["title"] as! [String:Any]
        titleLbl.text = titleDict["rendered"] as! String
        imgView.sd_setImage(with: URL.init(string: partiPost["jetpack_featured_media_url"] as! String)) { img, err, cache, url in
            self.bgImgView.image = img
        }
        
        let excerptDict = partiPost["excerpt"] as! [String:Any]
        excerptLbl.text = (excerptDict["rendered"] as! String).htmlToString
        
        fetchCoreData()
    }
    
    func fetchCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        request.predicate = NSPredicate(format: "id = %@", "\(partiPost["id"] as! Int)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            
            if result.count > 0 {
                bookmarkBtn.isSelected = true
            }
            else {
                bookmarkBtn.isSelected = false
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func designInit() {
        closeView.layer.cornerRadius = 15
        readPostBtn.layer.cornerRadius = 20
        readPostBtn.layer.borderWidth = 1
        readPostBtn.backgroundColor = .white
        readPostBtn.setTitleColor(.systemBlue, for: .normal)
        readPostBtn.layer.borderColor = UIColor.systemBlue.cgColor
        
        saveView.addBottomShadow()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.addSubview(blurEffectView)
    }
    
    @IBAction func readPostBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "postSegue", sender: nil)
    }
    
    @IBAction func bookMarkAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            request.predicate = NSPredicate(format: "id = %@", "\(partiPost["id"] as! Int)")
            request.returnsObjectsAsFaults = false

            do {
                let result = try context.fetch(request) as! [NSManagedObject]
                for object in result {
                    context.delete(object)
                }
                try context.save()
            } catch {
                
            }
        }
        else {
            sender.isSelected = true
            
            let entity = NSEntityDescription.entity(forEntityName: "Post", in: context)

            var newPost = NSManagedObject(entity: entity!, insertInto: context)
            
            newPost.setValue(Int64(partiPost["id"] as! Int), forKey: "id")
            newPost.setValue(partiPost["jetpack_featured_media_url"] as! String, forKey: "img_url")
            newPost.setValue(partiPost["link"] as! String, forKey: "post_url")
            
            let titleDict = partiPost["title"] as! [String:Any]
            newPost.setValue(titleDict["rendered"] as! String, forKey: "title")
            
            let excerptDict = partiPost["excerpt"] as! [String:Any]
            newPost.setValue((excerptDict["rendered"] as! String).htmlToString, forKey: "excerpt")
            do {
                try self.context.save()
            }
            catch {

            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            let vc = segue.destination as! PostVC
            vc.partiPost = partiPost
        }
    }
}

import UIKit
import CoreData

class BookmarkVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noBookmarkLbl: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var postArr = [NSManagedObject]()
    var partiPost = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCoreData()
    }
    
    func designInit() {
        topView.addBottomShadow()
    }
    
    func fetchCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            
            postArr = result.reversed()
            collectionView.reloadData()
            
            if postArr.count > 0 {
                noBookmarkLbl.isHidden = true
            }
            else {
                noBookmarkLbl.isHidden = false
            }
            
        } catch {
            
            noBookmarkLbl.isHidden = false
            print("Failed")
        }
    }
    
    //MARK: Collecionview delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 32, height: (self.view.frame.width - 32) * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 16
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = .zero
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        
        let partiPost = postArr[indexPath.row]
        
        cell.lbl.text = partiPost.value(forKey: "title") as! String
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        cell.imgView.sd_setImage(with: URL.init(string: partiPost.value(forKey: "img_url") as! String)) { img, err, cache, url in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parti = postArr[indexPath.row]
        
        partiPost = [
            "id": parti.value(forKey: "id") as! Int,
            "title": [
                "rendered": parti.value(forKey: "title") as! String
            ],
            "jetpack_featured_media_url": parti.value(forKey: "img_url") as! String,
            "link": parti.value(forKey: "post_url") as! String,
            "excerpt": [
                "rendered": parti.value(forKey: "excerpt") as! String
            ]
        ]
        
        self.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let vc = segue.destination as! DetailsVC
            vc.partiPost = partiPost
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

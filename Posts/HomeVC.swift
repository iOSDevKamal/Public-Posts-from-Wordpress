import UIKit
import Alamofire
import SDWebImage
import NVActivityIndicatorView

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nvActivityIndicator: NVActivityIndicatorView!
    
    var postArr = [[String:Any]]()
    var partiPost = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designInit()
        fetchData()
    }
    
    func fetchData() {
        nvActivityIndicator.startAnimating()
        let url = "https://techcrunch.com/wp-json/wp/v2/posts?per_page=100&context=embed"
        AF.request(url).responseJSON { result in
            if let value = result.value as? [[String:Any]] {
                self.nvActivityIndicator.stopAnimating()
                self.postArr = value
                self.collectionView.reloadData()
            }
        }
    }
    
    func designInit() {
        let path = UIBezierPath(roundedRect:self.view.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: 32, height: 32))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        mainView.layer.mask = maskLayer
    }
    
    //MARK: Collectionview delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 32, height: (self.view.frame.width - 32) * 0.8)
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
        
        let parti = postArr[indexPath.row]
        print(parti)
        let titleDict = parti["title"] as! [String:Any]
        cell.lbl.text = titleDict["rendered"] as! String
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        cell.imgView.sd_setImage(with: URL.init(string: parti["jetpack_featured_media_url"] as! String)) { img, err, cache, url in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parti = postArr[indexPath.row]
        partiPost = parti
        self.performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
    @IBAction func bookmarkAction(_ sender: Any) {
        self.performSegue(withIdentifier: "bookmarkSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let vc = segue.destination as! DetailsVC
            vc.partiPost = self.partiPost
        }
    }
}


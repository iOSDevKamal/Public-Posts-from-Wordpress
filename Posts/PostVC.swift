import UIKit
import WebKit

class PostVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var topView: UIView!
    var partiPost = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest.init(url: URL.init(string: partiPost["link"] as! String)!)
        webView.load(urlRequest)
        
        designInit()
    }
    
    func designInit() {
        topView.addBottomShadow()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

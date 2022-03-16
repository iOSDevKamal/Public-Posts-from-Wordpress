import Foundation
import CoreData

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var img_url: String?
    @NSManaged public var post_url: String?
    @NSManaged public var excerpt: String?

}

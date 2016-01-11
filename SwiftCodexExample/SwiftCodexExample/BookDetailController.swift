//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import UIKit
import SwiftCodex

public class BookDetailController: UITableViewController
{
    var book: Book!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    public override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        titleLabel.text = book.title
        yearLabel.text = book.year
        tagsLabel.text = book.transformedTags
        bookImageView.image = UIImage.image(forBook: book)
        
        if let author = book.author {
            firstNameLabel.text = author.firstName
            lastNameLabel.text = author.lastName
            authorImageView.image = UIImage.image(forAuthor: author)
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        guard
            let navController = segue.destinationViewController as? UINavigationController,
            let editController = navController.childViewControllers.first as? EditBookController else {
                return
        }
        editController.book = book
    }
}
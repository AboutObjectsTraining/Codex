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
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    public override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        yearLabel.text = book.year
        tagsLabel.text = book.transformedTags
        bookImageView.image = UIImage.image(forBook: book)
        
        if let author = book.author {
            authorImageView.image = UIImage.image(forAuthor: author)
        }
    }
    
    @IBAction func cancelEditingBook(segue: UIStoryboardSegue)
    {
        // do nothing
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
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let heart = "  " + (book.favorite == true ?
            FavoriteSymbol.FilledHeart.rawValue :
            FavoriteSymbol.BlankHeart.rawValue)
        
        switch (section) {
        case 0: return book.title + heart
        case 1: return book.author?.fullName
        default: return nil
        }
    }
}
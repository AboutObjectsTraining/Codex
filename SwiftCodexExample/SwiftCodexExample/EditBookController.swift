//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import UIKit

public class EditBookController: UITableViewController
{
    public var book: Book!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var tagsField: UITextField!
    
    public override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        titleField.text = book.title
        yearField.text = book.year
        tagsField.text = book.transformedTags
        
        titleField.becomeFirstResponder()
    }
    
    func updateBook()
    {
        book.title = titleField.text
        book.year = yearField.text
        book.transformedTags = tagsField.text
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "Done" {
            updateBook()
        }
    }
}
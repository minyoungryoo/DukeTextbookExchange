//
//  PostTableViewController.swift
//  YikYakClone
//
//  Created by Jesse Hu on 2/10/16.
//  Copyright © 2016 Jesse Hu. All rights reserved.
//

import UIKit
import CoreLocation

class PostTableViewController: UITableViewController, CLLocationManagerDelegate, PostTableViewCellDelegate {
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        //this is the segmented control to toggle between New and Hot
        //it is connected but not implemented
        switch sender.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return yaks().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostTableViewCell
        
        // Set delegate to get notified when the cell's upvote or downvote buttons are tapped
        cell.delegate = self
        cell.indexPath = indexPath
        
        let yak = yaks()[indexPath.row]
        cell.textView.text = yak.text
        
        cell.timeLabel.text = yak.timestampToReadable()
        
        if yak.replies.count > 0 {
            cell.repliesLabel.text = "💬 \(yak.replies.count) Replies"
        } else {
            cell.repliesLabel.text = "💬 Reply"
        }
        
        cell.voteCountLabel.text = String(yaks()[indexPath.row].netVoteCount)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //this is where we push to the Yak scene to show details about a Yak and the replies it has
        performSegueWithIdentifier("yakDetailSegue", sender: indexPath)
    }
    
    // MARK: - PostTableViewCell delegate
    
    func didUpvoteCellAtIndexPath(indexPath: NSIndexPath) {
        yaks()[indexPath.row].netVoteCount += 1
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PostTableViewCell
        cell?.voteCountLabel.text = String(yaks()[indexPath.row].netVoteCount)
    }
    
    func didDownvoteCellAtIndexPath(indexPath: NSIndexPath) {
        yaks()[indexPath.row].netVoteCount -= 1
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PostTableViewCell
        cell?.voteCountLabel.text = String(yaks()[indexPath.row].netVoteCount)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "yakDetailSegue" {
            if let detailVC = segue.destinationViewController as? DetailViewController,
                indexPath = sender as? NSIndexPath {
                //here is how we let the Yak scene know what Yak it needs to display
                detailVC.yak = yaks()[indexPath.row]
            }
        }
    }
    
    func yaks() -> [Yak]{
        let sampleYak = Yak(text: "Wow this weather is crazy.", timestamp: NSDate(), location: nil)
        sampleYak.replies.append(Reply(text: "I agree", timestamp: NSDate(), location: nil))
        return [sampleYak]
    }
    
    // MARK: - Private functions
    
    private func alert(message : String) {
        let alert = UIAlertController(title: "Oops something went wrong.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }


}

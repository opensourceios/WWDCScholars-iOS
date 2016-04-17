//
//  ScholarDetailViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit

class ScholarDetailViewController: UIViewController {
    @IBOutlet private weak var detailsTableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageViewBackground: UIView!
    
    var currentScholar: Scholar?
    
    override func viewDidLoad() {        
        self.styleUI()
        self.updateUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.profileImageViewBackground.applyRoundedCorners()
        self.profileImageView.applyRoundedCorners()
        
        self.profileImageView.clipsToBounds = true
        
        self.configureMap()
    }
    
    // MARK: - Private functions
    
    private func configureMap() {
        self.mapView.userInteractionEnabled = false
        
        let camera = MKMapCamera()
        camera.altitude = 7500
        camera.centerCoordinate.latitude = currentScholar!.location.latitude
        camera.centerCoordinate.longitude = currentScholar!.location.longitude
        
        self.mapView.setCamera(camera, animated: false)
    }
    
    private func updateUI() {
        self.title = currentScholar?.fullName
        
        self.locationLabel.text = currentScholar?.location.name
        self.nameLabel.text = currentScholar?.firstName
        self.profileImageView.af_setImageWithURL(NSURL(string: currentScholar!.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("basicDetailsTableViewCell") as! BasicDetailsTableViewCell
            
            var attendedString = ""
            for (index, batch) in currentScholar!.batchWWDC.enumerate() {
                attendedString.appendContentsOf(index != currentScholar!.batchWWDC.count - 1 ? "\(batch.shortVersion), " : batch.shortVersion)
            }
            
            cell.ageLabel.text = String(currentScholar!.age)
            cell.countryLabel.text = "Germany"
            cell.attendedLabel.text = attendedString
            
            return cell
        case 1:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("bioTableViewCell") as! BioTableViewCell
            
            cell.contentLabel.text = currentScholar?.shortBio
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            return 70.0
        case 1:
            return 110.0
        default:
            return 0.0
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let mapHeight: CGFloat = 156.0
        var mapFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: mapHeight)
        
        if scrollView.contentOffset.y < mapHeight {
            mapFrame.origin.y = scrollView.contentOffset.y
            mapFrame.size.height = -scrollView.contentOffset.y + mapHeight
        }
        
        self.mapView.frame = mapFrame
    }
}
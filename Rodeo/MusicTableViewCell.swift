//
//  MusicTableViewCell.swift
//  Rodeo
//
//  Created by Admin on 21/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var delegate: MusicCellDelegate?
    
    @IBAction func btnFavAction(_ sender: Any) {
        self.delegate?.didSelectFav(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

protocol MusicCellDelegate: NSObjectProtocol {
    func didSelectFav(cell: MusicTableViewCell)
}

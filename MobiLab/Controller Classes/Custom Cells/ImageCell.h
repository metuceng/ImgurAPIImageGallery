//
//  ImageCell.h
//  MobiLab
//
//  Created by Ahmet Abak on 17/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>
@interface ImageCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgImage;
@property (strong, nonatomic) IBOutlet UILabel *imgDesctiption;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

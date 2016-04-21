//
//  ImageDetailsViewController.h
//  MobiLab
//
//  Created by Ahmet Abak on 19/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImgurSession/ImgurSession.h>
@interface ImageDetailsViewController : UIViewController
@property (strong, nonatomic) id<IMGGalleryObjectProtocol> imp;
@end

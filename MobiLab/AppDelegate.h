//
//  AppDelegate.h
//  MobiLab
//
//  Created by Ahmet Abak on 14/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImgurSession/IMGSession.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, IMGSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void(^continueHandler)();

@end


//
//  ImgurLoginViewController.m
//  MobiLab
//
//  Created by Ahmet Abak on 16/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "ImgurLoginViewController.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>
#import <ImgurSession/IMGSession.h>
#import <ImgurSession/IMGGalleryRequest.h>
#import <ImgurSession/IMGImage.h>
#import <ImgurSession/IMGGalleryObject.h>
#import <ImgurSession/IMGAccount.h>
@interface ImgurLoginViewController()<UIWebViewDelegate>

@end


@implementation ImgurLoginViewController


- (void) viewDidAppear:(BOOL)animated
{
    [self reload];
}


-(void)reload{
    [IMGGalleryRequest hotGalleryPage:0 withViralSort:YES success:^(NSArray *objects)
    {
        NSLog(@"%@",[IMGSession sharedInstance].user.username);
        
        [self performSegueWithIdentifier:@"goToGallery" sender:self];
        
    } failure:^(NSError *error)
    {
        
        NSLog(@"gallery request failed - %@" ,error.localizedDescription);
    }];
    
    
}

- (IBAction)loginPressed:(id)sender
{
        //set your credentials to reset the session to your app
        [IMGSession authenticatedSessionWithClientID:CLIENT_ID
                                              secret:CLIENT_SECRET
                                            authType:IMGCodeAuth
                                        withDelegate:(id<IMGSessionDelegate>)[UIApplication sharedApplication].delegate];
    
    
    [self reload];
}



@end

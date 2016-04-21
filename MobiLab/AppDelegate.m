//
//  AppDelegate.m
//  MobiLab
//
//  Created by Ahmet Abak on 14/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "UIColor+AppColors.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UISegmentedControl appearance]  setBackgroundImage:[UIColor imageFromColor:[UIColor segmentedControlNotSelectedColor] withFrame:CGRectMake(0, 0, 200, 30)]
                                                forState:UIControlStateDisabled
                                              barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]  setBackgroundImage:[UIColor imageFromColor:[UIColor segmentedControlNotSelectedColor] withFrame:CGRectMake(0, 0, 200, 30)]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]  setBackgroundImage:[UIColor imageFromColor:[UIColor segmentedControlSelectedColor] withFrame:CGRectMake(0, 0, 200, 30)]
                                                forState:UIControlStateSelected
                                              barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]  setBackgroundImage:[UIColor imageFromColor:[UIColor segmentedControlNotSelectedColor] withFrame:CGRectMake(0, 0, 200, 30)]
                                                forState:UIControlStateHighlighted
                                              barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance]  setDividerImage:[UIImage new]
                                  forLeftSegmentState:UIControlStateNormal
                                    rightSegmentState:UIControlStateSelected
                                           barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]  setDividerImage:[UIImage new]
                                  forLeftSegmentState:UIControlStateSelected
                                    rightSegmentState:UIControlStateNormal
                                           barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]  setDividerImage:[UIImage new]
                                  forLeftSegmentState:UIControlStateNormal
                                    rightSegmentState:UIControlStateNormal
                                           barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor navBarTintColor]];
    
    
    // Override point for customization after application launch.
    [IMGSession authenticatedSessionWithClientID:CLIENT_ID
                                          secret:CLIENT_SECRET
                                        authType:IMGCodeAuth
                                    withDelegate:self];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:5   * 1024 * 1024
                                                            diskCapacity:120 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
   
    //app must register url scheme which starts the app at this endpoint with the url containing the code
    //NSLog(@"url %@", url);
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    NSString * pinCode = params[@"code"];
    
    if(!pinCode){
        NSLog(@"error: %@", params[@"error"]);
        
        self.continueHandler = nil;
        
        UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"error" message:@"Access was denied by Imgur" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try Again",nil];
        [a show];
        
        return NO;
    }
    
    NSLog(@"%@", pinCode);
    
    [[IMGSession sharedInstance] authenticateWithCode:pinCode];
    
    [[NSUserDefaults standardUserDefaults] setObject:pinCode forKey:@"pincode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(_continueHandler)
        self.continueHandler();
    
    
    return YES;
}


- (void)imgurSessionNeedsExternalWebview:(NSURL *)url completion:(void (^)())completion
{
    self.continueHandler = [completion copy];
    
    [[UIApplication sharedApplication] openURL:url];
}

-(void)imgurRequestFailed:(NSError *)error
{
    NSLog(@"imgur error %@", error.localizedDescription);
}

-(void)imgurSessionAuthStateChanged:(IMGAuthState)state
{
    NSLog(@"imgur state %ld", (long)state);
}

-(void)imgurSessionTokenRefreshed
{
    NSLog(@"new token");
}

@end

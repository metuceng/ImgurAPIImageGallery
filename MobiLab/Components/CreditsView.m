//
//  CreditsView.m
//  MobiLab
//
//  Created by Ahmet Abak on 21/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "CreditsView.h"

@implementation CreditsView

+(instancetype)new
{
    return [[UINib nibWithNibName:@"CreditsView" bundle:nil] instantiateWithOwner:[UIApplication sharedApplication] options:nil][0];
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}
@end

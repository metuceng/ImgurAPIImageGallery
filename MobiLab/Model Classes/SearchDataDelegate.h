//
//  SearchDataDelegate.h
//  MobiLab
//
//  Created by Ahmet Abak on 15/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDataDelegate <NSObject>

@required
- (void) newRequestAvailibleWithURL:(NSString *)requestURL;
- (void) newResultSetIsAvailible:(NSArray *)resultSet;
- (void) requestFailedWithError:(NSString *)errorDesctiption;
@end

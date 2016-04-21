//
//  SearchData.h
//  MobiLab
//
//  Created by Ahmet Abak on 15/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchDataDelegate.h"
#import <ImgurSession/ImgurSession.h>
@interface SearchData : NSObject

@property (assign, nonatomic) BOOL          showViral ;
@property (strong, nonatomic) NSString      *section  ;
@property (strong, nonatomic) NSString      *sort     ;
@property (assign, nonatomic) IMGTopGalleryWindow window;
@property (strong, nonatomic) NSArray       *resultSet;
@property (assign, nonatomic) int page;
+ ( instancetype ) sharedSearchData;
- (void)setPage:(int)page;
- (void)setWindow:(IMGTopGalleryWindow)window;
- (void)setSort:(NSString *)sort;
- (void)setSection:(NSString *)section;
- (void)setShowViral:(BOOL)showViral;
- (void)setResultSet:(NSArray *)resultSet;

@property (weak,   nonatomic) id<SearchDataDelegate> delegate;

@end

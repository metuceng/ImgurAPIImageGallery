//
//  SearchData.m
//  MobiLab
//
//  Created by Ahmet Abak on 15/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "SearchData.h"
@interface SearchData()

@end

@implementation SearchData

@synthesize showViral = _showViral  ;
@synthesize window    = _window     ;
@synthesize sort      = _sort       ;
@synthesize section   = _section    ;
@synthesize page      = _page       ;
@synthesize resultSet = _resultSet  ;

+ ( instancetype ) sharedSearchData
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- ( instancetype ) init
{
    self = [super init];
    
    if (self)
    {
        _showViral = YES;
        _window    = IMGTopGalleryWindowDay;
        _section   = @"hot";
        _sort      = @"viral";
        _page      = 1;
    }
    return self;
}



#pragma mark -SETTERS

- (void)setPage:(int)page
{
    _page = page;
}

- (void)setWindow:(IMGTopGalleryWindow)window
{
    _window = window;
}

- (void)setSort:(NSString *)sort
{
    _sort = sort;
}

- (void)setSection:(NSString *)section
{
    _section = section;
}

- (void)setShowViral:(BOOL)showViral
{
    _showViral = showViral;
}

- (void)setResultSet:(NSArray *)resultSet
{
}


@end

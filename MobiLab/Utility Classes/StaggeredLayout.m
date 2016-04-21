//
//  StaggeredLayout.m
//  MobiLab
//
//  Created by Ahmet Abak on 17/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "StaggeredLayout.h"

@implementation StaggeredLayout
{
    CGFloat contentWidth, contentHeight;
    NSMutableArray *cache;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        cache = [NSMutableArray new];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    int total = (int)[self.collectionView numberOfItemsInSection:0];
    
    if ([cache count] == 0)
    {
        CGFloat wid = self.collectionView.bounds.size.width;
        
        contentWidth = wid;
        contentHeight = ceil(total/ 3.0)*wid*0.666;
        
        for (int i = 0; i< total; i++)
        {
            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
            
            CGFloat width, height;
            CGFloat x, y;
            
            if ((i % 3 == 0 && ((i / 3) % 2) == 0)  ||( i % 3 == 1 && ((i / 3) % 2) == 1) )
            {
                width = wid * 0.66;
                height = width;
                
                if ((i % 3 == 0 && ((i / 3) % 2) == 0))
                {
                    x = 0;
                }
                else
                {
                    x = width*0.5;
                }
                y = (i/3)*height;
            }
            else
            {
                width = wid * 0.33;
                height = width;
                
                if ( (((i / 3) % 2) == 0) && ((i % 3) == 1) )
                {
                    x = width * 2;
                    y = (i / 3) * height * 2;
                }
                else if( (((i / 3) % 2) == 0) && ((i % 3) == 2) )
                {
                    x = width * 2;
                    y = (i / 3) * height * 2 + height;
                }
                else if( (((i / 3) % 2) == 1) && ((i % 3) == 0) )
                {
                    x = 0;
                    y = (i / 3) * height * 2;
                }
                else
                {
                    x = 0;
                    y = (i / 3) * height * 2 + height;
                }
            }
            
            CGRect rect = CGRectMake(x, y, width, height);
            
            rect = CGRectInset(rect, 2, 2);
            
            UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForCellWithIndexPath:path];

            
            attributes.frame = rect;
            
            
            
            
            [cache addObject:attributes];
            
        }
    }
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(contentWidth, contentHeight);
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *a in cache)
    {
        if (CGRectIntersectsRect(a.frame, rect)) {
            [attributes addObject:a];
        }
    }
    
    return [attributes copy];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cache count])
        return cache[indexPath.row];
    else
        return [super layoutAttributesForItemAtIndexPath:indexPath];
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    [cache removeAllObjects];
}

@end

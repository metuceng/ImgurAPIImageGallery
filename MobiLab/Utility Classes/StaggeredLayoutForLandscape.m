//
//  StaggeredLayout.m
//  MobiLab
//
//  Created by Ahmet Abak on 17/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "StaggeredLayoutForLandscape.h"

@implementation StaggeredLayoutForLandscape
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
        contentHeight = ceil(total/ 5.0)*wid*0.5;
        
        for (int i = 0; i< total; i+=5)
        {
            NSArray *frames = [self frameSetForFamilyWithMemberAtIndex:i bigOneInPosition:arc4random_uniform(3)];
            
            int k = i;
            int l = i+5;
            if (l > total) {
                l = total;
            }
            
            for (; k < l; k++)
            {
                NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:0];
                UICollectionViewLayoutAttributes *attributes = [[[self class] layoutAttributesClass] layoutAttributesForCellWithIndexPath:path];
                
                attributes.frame = [[frames objectAtIndex:(k % 5)] CGRectValue];
                [cache addObject:attributes];
            }
        }
    }
}

- (NSArray *)frameSetForFamilyWithMemberAtIndex:(int)index bigOneInPosition:(int)position
{
    NSArray *frames;
    
    CGFloat wid = self.collectionView.bounds.size.width;
    
    CGFloat bigWidth = wid * 0.5f;
    CGFloat smallWid = wid * 0.25f;
    
    CGRect rect1, rect2, rect3, rect4, rect5;
    
    if (position == 0)
    {//first one is big;
        
        rect1 = CGRectMake(0, 0, bigWidth, bigWidth);
        rect2 = CGRectMake(0, 0, smallWid, smallWid);
        rect3 = CGRectMake(0, 0, smallWid, smallWid);
        rect4 = CGRectMake(0, 0, smallWid, smallWid);
        rect5 = CGRectMake(0, 0, smallWid, smallWid);
        
        rect1.origin.x = 0;
        rect1.origin.y = bigWidth * (index / 5);
        
        rect2.origin.x = bigWidth;
        rect3.origin.x = bigWidth + smallWid;
        rect2.origin.y = bigWidth * (index / 5);
        rect3.origin.y = bigWidth * (index / 5);
        
        rect4.origin.x = bigWidth;
        rect5.origin.x = bigWidth + smallWid;
        rect4.origin.y = bigWidth * (index / 5) + smallWid;
        rect5.origin.y = bigWidth * (index / 5) + smallWid;
    }
    else if(position == 1)
    {// second one is big
        
        rect1 = CGRectMake(0, 0, smallWid, smallWid);
        rect2 = CGRectMake(0, 0, bigWidth, bigWidth);
        rect3 = CGRectMake(0, 0, smallWid, smallWid);
        rect4 = CGRectMake(0, 0, smallWid, smallWid);
        rect5 = CGRectMake(0, 0, smallWid, smallWid);
        
        rect1.origin.x = 0;
        rect1.origin.y = bigWidth * (index / 5);
        
        rect2.origin.x = smallWid;
        rect3.origin.x = bigWidth + smallWid;
        rect2.origin.y = bigWidth * (index / 5);
        rect3.origin.y = bigWidth * (index / 5);
        
        rect4.origin.x = 0;
        rect5.origin.x = bigWidth + smallWid;
        rect4.origin.y = bigWidth * (index / 5) + smallWid;
        rect5.origin.y = bigWidth * (index / 5) + smallWid;
    }
    else
    {
        
        rect1 = CGRectMake(0, 0, smallWid, smallWid);
        rect2 = CGRectMake(0, 0, smallWid, smallWid);
        rect3 = CGRectMake(0, 0, bigWidth, bigWidth);
        rect4 = CGRectMake(0, 0, smallWid, smallWid);
        rect5 = CGRectMake(0, 0, smallWid, smallWid);
        
        rect1.origin.x = 0;
        rect1.origin.y = bigWidth * (index / 5);
        
        rect2.origin.x = smallWid;
        rect3.origin.x = bigWidth;
        rect2.origin.y = bigWidth * (index / 5);
        rect3.origin.y = bigWidth * (index / 5);
        
        rect4.origin.x = 0;
        rect5.origin.x = smallWid;
        rect4.origin.y = bigWidth * (index / 5) + smallWid;
        rect5.origin.y = bigWidth * (index / 5) + smallWid;
        
    }
    
    frames = @[[NSValue valueWithCGRect:CGRectInset(rect1, 2, 2)],
               [NSValue valueWithCGRect:CGRectInset(rect2, 2, 2)],
               [NSValue valueWithCGRect:CGRectInset(rect3, 2, 2)],
               [NSValue valueWithCGRect:CGRectInset(rect4, 2, 2)],
               [NSValue valueWithCGRect:CGRectInset(rect5, 2, 2)]];
    
    return frames;
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

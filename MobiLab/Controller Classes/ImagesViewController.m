//
//  ImagesViewController.m
//  MobiLab
//
//  Created by Ahmet Abak on 15/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "ImagesViewController.h"
#import "SearchData.h"
#import "Constants.h"
#import <ImgurSession/ImgurSession.h>
#import "ImageCell.h"
#import "StaggeredLayout.h"
#import "StaggeredLayoutForLandscape.h"
#import "ImageDetailsViewController.h"
#import "UIColor+AppColors.h"
#import "CreditsView.h"
@interface ImagesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *imgDataSource;
@end

@implementation ImagesViewController
{
    __weak IBOutlet NSLayoutConstraint *windowHeightConstraint;
    __weak IBOutlet UISegmentedControl *windowSegments;
    __weak IBOutlet UISegmentedControl *sections;
    __weak IBOutlet UICollectionView *gridView;
    ShowStyle style;
    SearchData *searchData;
    CreditsView *creditsView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpGridLayoutForTransition:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    style = SS_LIST;
    [self.navigationController.navigationBar setTintColor:[UIColor navBarTintColor]];
    searchData = [SearchData sharedSearchData];
    [gridView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    
    gridView.dataSource = self;
    gridView.delegate   = self;
    
    // Do any additional setup after loading the view.
    [self loadImagesForHotSection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Setters

-(void)setImgDataSource:(NSArray *)ids
{
    _imgDataSource = ids;
    [gridView.collectionViewLayout invalidateLayout];
    [gridView setContentOffset:CGPointZero animated:YES];
    [gridView reloadData];
}


#pragma mark -SegmentedControl Events

- (IBAction)sectionChanged:(id)sender
{
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    switch (s.selectedSegmentIndex)
    {
        case ST_TOP:
            [self loadImagesForTopSection];
            break;
        case ST_HOT:
            [self loadImagesForHotSection];
            break;
        case ST_USER:
            [self loadImagesForUserSection];
            break;
    }
}

- (IBAction)windowChanged:(id)sender
{
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    switch (s.selectedSegmentIndex) {
        case 0:
            searchData.window = IMGTopGalleryWindowDay;
            break;
        case 1:
            searchData.window = IMGTopGalleryWindowWeek;
            break;
        case 2:
            searchData.window = IMGTopGalleryWindowMonth;
            break;
        case 3:
            searchData.window = IMGTopGalleryWindowYear;
            break;
        case 4:
            searchData.window = IMGTopGalleryWindowAll;
            break;
    }
    
    [self loadImagesForTopSection];
}


- (IBAction)aboutUsClicked:(id)sender
{
    if ([creditsView isDescendantOfView:self.view]) {
        [creditsView removeFromSuperview];
        return;
    }
    
    if (!creditsView)
    {
        creditsView  = [CreditsView new];
        creditsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    
    creditsView.translatesAutoresizingMaskIntoConstraints = YES;
    creditsView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:creditsView];
    
}

- (IBAction)viralToggled:(id)sender
{
    
    if ([creditsView isDescendantOfView:self.view]) {
        [creditsView removeFromSuperview];
    }
    
    if ([sender tag] == 0)
    {
        [sender setTag:1];
        [sender setTintColor:[[UIColor navBarTintColor] colorWithAlphaComponent:0.2]];
        searchData.showViral = NO;
    }
    else
    {
        [sender setTag:0];
        [sender setTintColor:[UIColor navBarTintColor]];
        searchData.showViral = YES;
    }
    
    [self sectionChanged:sections];
}

- ( void )closeWindow
{
    windowHeightConstraint.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- ( void )openWindow
{
    
    windowHeightConstraint.constant = 35;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)layoutOptionChanged:(id)sender
{
    if ([creditsView isDescendantOfView:self.view]) {
        [creditsView removeFromSuperview];
    }
    
    if ([sender tag] == 1)
    {
        style = SS_STAGGERED;
        if (IS_LANDSCAPE) {
                [gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[StaggeredLayoutForLandscape new]
                                         animated:YES];
        }
        else
        {
                [gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[StaggeredLayout new]
                                         animated:YES];
        }
        
        [sender setTag:2];
        UIBarButtonItem *b = (UIBarButtonItem *)sender;
        [b setImage:[UIImage imageNamed:@"icon_staggered"]];
    }
    else if( [sender tag] == 0)
    {
        style = SS_GRID;
        [gridView setCollectionViewLayout:[UICollectionViewFlowLayout new]
                                     animated:YES];
        [sender setTag:1];
        UIBarButtonItem *b = (UIBarButtonItem *)sender;
        [b setImage:[UIImage imageNamed:@"icon_grid"]];
    }
    else
    {
        style = SS_LIST;
            [gridView.collectionViewLayout invalidateLayout];
            [gridView setCollectionViewLayout:[UICollectionViewFlowLayout new]
                                     animated:YES];
        [sender setTag:0];
        UIBarButtonItem *b = (UIBarButtonItem *)sender;
        [b setImage:[UIImage imageNamed:@"icon_list"]];
    }
}

#pragma mark -Load Actions
- (void)loadImagesForHotSection
{
    self.imgDataSource = nil;
    [IMGGalleryRequest hotGalleryPage:searchData.page
                        withViralSort:searchData.showViral
                              success:^(NSArray *objects){
                                  self.imgDataSource = objects;
                              }
                              failure:^(NSError *error){
                                  
                              }];
    [self closeWindow];
}

- (void)loadImagesForTopSection
{
    self.imgDataSource = nil;
    [IMGGalleryRequest topGalleryPage:searchData.page
                           withWindow:searchData.window
                        withViralSort:searchData.showViral
                              success:^(NSArray * objects) {
                                  self.imgDataSource = objects;
                              }
                              failure:^(NSError *error) {
                                  
                              }];
    [self openWindow];
}

- (void)loadImagesForUserSection
{
    self.imgDataSource = nil;
    [IMGGalleryRequest userGalleryPage:searchData.page
                         withViralSort:YES
                             showViral:searchData.showViral
                               success:^(NSArray *objects) {
                                   self.imgDataSource = objects;
                               }
                               failure:^(NSError *error) {
                                   
                               }];
    [self closeWindow];
}

#pragma mark -CollectionViewDelegate and Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell"
                                                                forIndexPath:indexPath];

    cell.imgImage.image = nil;
    cell.imgDesctiption.text = nil;
    
    id<IMGGalleryObjectProtocol> imp = _imgDataSource[indexPath.row];
    IMGImage *image = [imp coverImage];
    
    [cell.imgDesctiption setText:[image imageDescription]];
    
    __weak ImageCell *c = cell;
    
    if ([[[image url] relativeString] hasSuffix:@".gif"])
    {
        [cell.imgImage setImageWithURLRequest:[NSURLRequest requestWithURL:[image url]
                                                               cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                           timeoutInterval:30]
                             placeholderImage:[UIImage imageNamed:@"placeholder"]
                                      success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                          c.imgImage.image = image;
                                      }
                                      failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                          
                                      }];
    }
    else
    {
        [cell.imgImage setImageWithURLRequest:[NSURLRequest requestWithURL:[image URLWithSize:IMGBigSquareSize]
                                                               cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                           timeoutInterval:30]
                         placeholderImage:[UIImage imageNamed:@"placeholder"]
                                  success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                      c.imgImage.image = image;
                         }
                                  failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                      
                                      [c.imgImage setImageWithURL:[image url]
                                                    placeholderImage:[UIImage imageNamed:@"placeholder"]];
                         }];
    
    }
    cell.imgDesctiption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    if ([image imageDescription] == nil || [[image imageDescription] isEqualToString:@""]) {
        
        [cell.imgDesctiption setText:@"-"];
    }
    
    [cell.upLabel       setText:[NSString stringWithFormat:@"%d", (int)[imp ups]]];
    [cell.downLabel     setText:[NSString stringWithFormat:@"%d", (int)[imp downs]]];
    [cell.commentLabel  setText:[NSString stringWithFormat:@"%d", (int)[imp score]]];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //request details of book here
    ImageDetailsViewController *vc = (ImageDetailsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImagesVC"];
    vc.imp = [_imgDataSource objectAtIndex:indexPath.row];
    //[gridView.collectionViewLayout invalidateLayout];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imgDataSource count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_LANDSCAPE && style == SS_LIST)
    {
        return CGSizeMake(gridView.bounds.size.width*0.5, gridView.bounds.size.width *0.166);
    }
    else if (IS_LANDSCAPE && style == SS_GRID)
    {
        return CGSizeMake(gridView.bounds.size.width *0.19, gridView.bounds.size.width*0.19);
    }
    else if (style == SS_LIST)
    {
        return CGSizeMake(gridView.bounds.size.width, gridView.bounds.size.width* 0.33);
    }
    return CGSizeMake(gridView.bounds.size.width *0.33, gridView.bounds.size.width*0.33);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void) setUpGridLayoutForTransition:(BOOL)transition
{
    CGSize size = self.view.bounds.size;
    
    if (!transition)
    {
        [gridView.collectionViewLayout invalidateLayout];
        
        if (IS_LANDSCAPE && style == SS_STAGGERED)
        {
            [gridView setCollectionViewLayout:[StaggeredLayoutForLandscape new]
                                     animated:NO];
        }
        else if (IS_LANDSCAPE == NO && style == SS_STAGGERED)
        {
            [gridView setCollectionViewLayout:[StaggeredLayout new]
                                     animated:NO];
            
        }
        else
        {
            [gridView setCollectionViewLayout:[UICollectionViewFlowLayout new] animated:NO];
        }
        
        return;
    }
    
    
    if (size.width > size.height)
    {//going to landscape mode
        if ([gridView.collectionViewLayout isKindOfClass:[StaggeredLayout class]]) {
                //[gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[StaggeredLayoutForLandscape new]
                                         animated:YES];
        }
        else
        {
                //[gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[UICollectionViewFlowLayout new]
                                         animated:YES];
        }
    }
    else
    {//going to portrait
        if ([gridView.collectionViewLayout isKindOfClass:[StaggeredLayoutForLandscape class]]) {
                //[gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[StaggeredLayout new]
                                         animated:YES];
        }
        else
        {
                //[gridView.collectionViewLayout invalidateLayout];
                [gridView setCollectionViewLayout:[UICollectionViewFlowLayout new]
                                         animated:YES];
        }
    }


}


//transition
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
        
        [self setUpGridLayoutForTransition:YES];
        
     }];
        
}

@end

//
//  ImageDetailsViewController.m
//  MobiLab
//
//  Created by Ahmet Abak on 19/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "ImageDetailsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ImageDetailsViewController ()<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *gifView;
    __weak IBOutlet UIImageView *hugeImage;
    IBOutletCollection(UILabel) NSArray *labels;
}
@end

@implementation ImageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IMGImage *_image = [_imp coverImage];
    
    if ([_image animated])
    {
        [gifView setHidden:NO];
        
        NSString *link = [[_image link] absoluteString];
        
        link = [link stringByReplacingOccurrencesOfString:@".gif" withString:@".mp4"];
        
        [gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
        gifView.delegate = self;
    }
    else
    {
        [gifView setHidden:YES];
        [hugeImage setImageWithURLRequest:[NSURLRequest requestWithURL:[_image url]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:30]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]
                                 success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                     hugeImage.image = image;
                                 }
                                 failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 }];
    }
    
    [labels[0] setText:[_image title]];
    [labels[1] setText:[NSString stringWithFormat:@"%d", (int)[_imp ups]]];
    [labels[2] setText:[NSString stringWithFormat:@"%d", (int)[_imp downs]]];
    [labels[3] setText:[NSString stringWithFormat:@"%d", (int)[_imp score]]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

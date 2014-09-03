//
//  WebViewController.m
//  NerdFeed
//
//  Created by Luis Carbuccia on 8/31/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

#pragma mark - View Controller Life Cycle

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // if an URL has been set, load web page
    if (_URL)
    {
        NSURLRequest *request =[NSURLRequest requestWithURL:_URL];
        [self.webView loadRequest:request];
    }
}

//- (void) loadView
//{
//    UIWebView *webView = [[UIWebView alloc] init];
//    webView.scalesPageToFit = YES;
//    self.view = webView;
//}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;

    if (_URL)
    {
        NSURLRequest *request =[NSURLRequest requestWithURL:_URL];
        [self.webView loadRequest:request];
    }
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

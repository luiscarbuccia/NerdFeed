//
//  CoursesTableViewController.m
//  NerdFeed
//
//  Created by Luis Carbuccia on 8/30/14.
//  Copyright (c) 2014 Luis Carbuccia. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "WebViewController.h"

@interface CoursesTableViewController () <NSURLSessionDataDelegate, UISplitViewControllerDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSArray *courses;

//@property (nonatomic, strong) WebViewController *webViewController;

@end

@implementation CoursesTableViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self fetchFeed];
//    self.webViewController = [[WebViewController alloc]init];
}

//- (instancetype) initWithStyle:(UITableViewStyle)style
//{
//    // create NSURLSession object
//    
//    self = [super initWithStyle:style];
//    if (self)
//    {
//        self.navigationItem.title = @"BNR Courses";
//        
//        [self fetchFeed];
//        
//    }
//    
//    return self;
//}

#pragma mark - Methods

- (void) fetchFeed
{
    // create an NSURLRequest that connects to bookapi.bignerdranch.com and asks for the list of courses
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:nil];
    
    // use NSURLSession to create an NSURLSessionTask that transfers request to the server
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
        self.courses = jsonDictionary[@"courses"];
        
        // get main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

#pragma mark - Table View delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    
    id detail = self.splitViewController.viewControllers[1];

    if (detail)
        [self prepareWebViewController:detail toLaunchURL:URL];
    else
        [self performSegueWithIdentifier:@"toWebView" sender:URL];
    
//    self.webViewController.title = course[@"title"];
//    self.webViewController.URL = URL;
//    [self.navigationController pushViewController:self.webViewController animated:YES];
    
//    [self performSegueWithIdentifier:@"toWebView" sender:URL];
}


#pragma mark - Delegate Methods

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"BigNerdRanch"
                                                             password:@"AchieveNerdvana"
                                                          persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareWebViewController:(WebViewController *)webVC toLaunchURL:(NSURL *)URL
{
    webVC.URL = URL;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toWebView"])
    {
        WebViewController *webVC = segue.destinationViewController;
        webVC.URL = sender;
    }
}


@end

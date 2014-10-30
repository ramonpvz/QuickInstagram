//
//  PhotoViewController.m
//  QuickInstagram
//
//  Created by Eduardo Alvarado Díaz on 10/27/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoDetailViewController.h"
#import "QuickInstagram-Swift.h"
#import "ImgCustomCell.h"
#import "TopicViewController.h"
#import "ITopic.h"
#import "IPhoto.h"
#import "IComment.h"
#import "ILike.h"
#import "IUser.h"

@interface PhotoViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *allImages;
@property NSArray *filteredResults;
@property NSArray *results;
@property NSArray *topics;
@property MBProgressHUD *HUD;
@property MBProgressHUD *refreshHUD;
@property UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property NSString *criteria;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //checking if a user is logged
    if ([PFUser currentUser] == nil) {
        self.tabBarController.selectedIndex = 0;
    }
    [[self tableView] reloadData];
    //NSLog(@"user=%@", DatabaseManager.loggedUser);
    self.topics = [[NSArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshDisplay) forControlEvents:UIControlEventValueChanged];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //checking if a user is logged
    if ([PFUser currentUser] == nil) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self refreshDisplay];
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void) refreshDisplay {
    NSLog(@"Searching for: %@",self.criteria);
    if (![self.searchBar.text isEqualToString:@""])
        self.criteria = self.searchBar.text;
    PFQuery *query = [PFQuery queryWithClassName:[ITopic parseClassName]];
    [query whereKey:@"hashtag" equalTo:self.criteria];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
        }
        else
        {
            self.results = objects;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            self.searchDisplayController.active = NO;
        }
    }];
}

#pragma mark - Main methods

- (IBAction)refresh:(id)sender
{

}

- (IBAction)cameraButtonTapped:(id)sender
{
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // Delegate is self
    imagePicker.delegate = self;

    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }
    else{
        // Device has no camera

        // Set source to the camera
        //imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }

    // Show image picker
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)uploadImage:(NSData *)imageData caption:(NSString *)caption topic:(NSString *)hashtag
{
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];

    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];

    // Set determinate mode
    self.HUD.mode = MBProgressHUDModeDeterminate;
    self.HUD.delegate = self;
    self.HUD.labelText = @"Uploading";
    [self.HUD show:YES];

    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [self.HUD hide:YES];

            // Show checkmark
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];

            self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

            // Set custom view mode
            self.HUD.mode = MBProgressHUDModeCustomView;

            self.HUD.delegate = self;

            // Create a PFObject around a PFFile and associate it with the current user
            PFUser *user = DatabaseManager.loggedUser;
            IPhoto *photo = [IPhoto object];

            // Search topic
            NSLog(@"Searching topic for: %@",hashtag);

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashtag=%@",hashtag];
            PFQuery *queryTopic = [PFQuery queryWithClassName:[ITopic parseClassName] predicate:predicate];

            [queryTopic findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error){
                    NSLog(@"Error: %@", error.userInfo);
                }
                else{
                    self.topics = objects;
                    NSLog(@"topics: %lu",self.topics.count);

                    photo.image = imageFile;
                    photo.caption = caption;
                    photo.user = user;
                    // Set the access control list to current user for security purposes
                    photo.ACL = [PFACL ACLWithUser:user];

                    if (self.topics.count > 0) {
                        for (ITopic *topicFound in self.topics) {
                            if ([topicFound.hashtag isEqualToString:hashtag]) {
                                NSLog(@"topic found: %@",topicFound.objectId);
                                photo.topic = topicFound;
                                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Image saved");
                                        [self refresh:nil];
                                    }else{
                                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                                    }
                                }];
                            }
                        }
                    }else{
                        ITopic *topic = [ITopic object];
                        topic.hashtag = hashtag;
                        [topic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSLog(@"topic new: %@",topic.objectId);
                                photo.topic = topic;
                                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Image saved");
                                        [self refresh:nil];
                                    }else{
                                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                                    }
                                }];
                            }
                        }];
                    }
                }
            }];
        }
        else{
            [self.HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        self.HUD.progress = (float)percentDone/100;
    }];
}


#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);


    // Set caption
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Caption" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter a caption";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter one Hastag";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Uploading photo");
        [self uploadImage:imageData caption:[alert.textFields[0] text] topic:[alert.textFields[1] text]];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel upload" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"wallSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)collectionImageView {
    
    if ([segue.identifier isEqualToString:@"wallSegue"])
    {
        TopicViewController *targetVC = segue.destinationViewController;
        targetVC.topic = [self.results objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }

}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSLog(@"filter content...");
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredResults.count;
    }
    return self.results.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITopic *topic;
    ImgCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImgCustomCell"];
    if (!cell) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ImgCustomCell" bundle:nil] forCellReuseIdentifier:@"ImgCustomCell"];
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImgCustomCell"];
    }
    if (self.tableView == self.searchDisplayController.searchResultsTableView)
    {
        topic = [self.filteredResults objectAtIndex:indexPath.row];
        PFFile *file = topic.icon;
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error) {
                cell.imgView.image = [UIImage imageWithData:data];
            }
        }];
        cell.hashtag.text = @"...";
    }
    else
    {
        topic = [self.results objectAtIndex:indexPath.row];
        PFFile *file = topic.icon;
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error) {
                cell.imgView.image = [UIImage imageWithData:data];
            }
        }];
        cell.hashtag.text = topic.hashtag;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


@end

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

@interface PhotoViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property IBOutlet UIScrollView *photoScrollView;
@property NSMutableArray *allImages;
@property NSArray *filteredResults;
@property NSArray *results;
@property MBProgressHUD *HUD;
@property MBProgressHUD *refreshHUD;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tableView] reloadData];
    NSLog(@"user=%@", DatabaseManager.loggedUser);
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self refreshDisplay];
}

- (void) refreshDisplay {
    NSLog(@"Searching for: %@",self.searchBar.text);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashtag = %@",self.searchBar.text];
    PFQuery *query = [PFQuery queryWithClassName:@"Topic" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
        }
        else
        {
            self.results = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Main methods

- (IBAction)refresh:(id)sender
{
    NSLog(@"Showing Refresh HUD");
    self.refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.refreshHUD];

    // Register for HUD callbacks so we can remove it from the window at the right time
    self.refreshHUD.delegate = self;

    // Show the HUD while the provided method executes in a new thread
    [self.refreshHUD show:YES];

    /*PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query orderByAscending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (self.refreshHUD) {
                [self.refreshHUD hide:YES];

                self.refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:self.refreshHUD];

                self.refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

                // Set custom view mode
                self.refreshHUD.mode = MBProgressHUDModeCustomView;

                self.refreshHUD.delegate = self;
            }
            NSLog(@"Successfully retrieved %lu photos.", objects.count);


            // Array of images
            [self setUpImages:self.allImages];

        } else {
            [self.refreshHUD hide:YES];

            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
    [self.refreshHUD hide:YES];
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

- (void)uploadImage:(NSData *)imageData caption:(NSString *)caption
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
            PFObject *userPhoto = [PFObject objectWithClassName:@"Photo"];
            [userPhoto setObject:imageFile forKey:@"image"];
            [userPhoto setObject:caption forKey:@"caption"];

            PFUser *user = DatabaseManager.loggedUser;

            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:user];

            [userPhoto setObject:user forKey:@"user"];

            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
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

- (void)setUpImages:(NSArray *)images
{
    NSLog(@"setupImages method");
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
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Uploading photo");
        [self uploadImage:imageData caption:[alert.textFields[0] text]];

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
    NSDictionary *topic;
    ImgCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImgCustomCell"];
    if (!cell) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ImgCustomCell" bundle:nil] forCellReuseIdentifier:@"ImgCustomCell"];
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ImgCustomCell"];
    }
    if (self.tableView == self.searchDisplayController.searchResultsTableView)
    {
        topic = [self.filteredResults objectAtIndex:indexPath.row];
        cell.imgView = [topic objectForKey:@"icon"];
        cell.hashtag.text = @"...";
    }
    else
    {
        topic = [self.results objectAtIndex:indexPath.row];
        PFFile *file = [topic objectForKey:@"icon"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error) {
                cell.imgView.image = [UIImage imageWithData:data];
            }
        }];
        cell.hashtag.text = [[topic objectForKey:@"hashtag"] description];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


@end

//
//  TICameraControllerViewController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TICameraControllerViewController.h"
#import "TITags.h"

@interface TICameraControllerViewController ()

- (IBAction)textComplete:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (nonatomic, strong) NSArray *potentialGroups;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)groupSelectDone:(id)sender;

@end

@implementation TICameraControllerViewController {
    bool cameraHasPopped;
}
@synthesize searchField = _searchField;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleField becomeFirstResponder];
    [self.searchField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGroups
{
    [TITags tagsForString:nil withCallback:^(NSArray *results) {
        self.potentialGroups = results;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"group"])
    {
        ((TICameraControllerViewController *)segue.destinationViewController).delegate = self.delegate;
        self.poi.title = self.titleField.text;
        self.poi.details = self.detailsField.text;
        [((TICameraControllerViewController *)segue.destinationViewController) loadGroups];
        ((TICameraControllerViewController *)segue.destinationViewController).poi = self.poi;
    }
    else
    {
        ((TICameraControllerViewController *)segue.destinationViewController).delegate = self.delegate;
        TIPointOfInterest *poi = [[TIPointOfInterest alloc] init];
        poi.image = self.ImageView.image;
        ((TICameraControllerViewController *)segue.destinationViewController).poi = poi;
    }
}
- (IBAction)textComplete:(id)sender {
    self.poi.title = self.titleField.text;
    self.poi.details = self.detailsField.text;
    [self.delegate camera:self didCreatePOI:self.poi];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [self textComplete:textView];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [capturedImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.ImageView.image = smallImage;
    self.poi.image = smallImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
    cell.textLabel.text = self.potentialGroups[indexPath.row][@"group"];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *allText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [TITags tagsForString:allText withCallback:^(NSArray *results) {
        self.potentialGroups = results;
        [self.tableView reloadData];
    }];

    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.potentialGroups count];
}

- (IBAction)groupSelectDone:(id)sender {
    self.poi.group = self.searchField.text;
    [self.delegate camera:self didCreatePOI:self.poi];
}
@end

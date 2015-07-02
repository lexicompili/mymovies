//
//  MMHomeViewController.m
//  MyMovies
//
//  Created by Mary Alexis Solis on 7/2/15.
//  Copyright (c) 2015 Mary Alexis Solis. All rights reserved.
//

#import "MMHomeViewController.h"
#import "MMCustomCell.h"
#import "MMLoadingCell.h"

@interface MMHomeViewController ()

@end

@implementation MMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeView = [[[NSBundle mainBundle] loadNibNamed:@"MMHome" owner:self options:nil] firstObject];
    [self.view addSubview:self.homeView];
    
    
    //Set delegates value
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
    
    self.navigationItem.title = @"MY MOVIES";
    self.offset = 0;
    
    //Web Service Client
    self.webServiceManager = [MMHTTPClient sharedManager];
    self.webServiceManager.delegate = self;
    [self.webServiceManager getMovies:self.offset+1];
    
    //Initialize
    self.movies = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 0;
    if(y > h + reload_distance) {
        //NSLog(@"offset before call: %d",self.offset);
        if(self.movies.count != 0)
            [self.webServiceManager getMovies:self.offset+1];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [@(section + 1) stringValue];
    NSDate *now = [NSDate date];
    NSDate *date = [now dateByAddingTimeInterval:section*24*60*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMMM dd yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    if(self.movies.count == 0)
        return @"";
    return stringFromDate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.movies.count == 0)
        return 1;
    return self.movies.count/9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.movies.count == 0)
        return 1;
    else if(section == self.movies.count/9 - 1)
        return 10;
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMCustomCell *cell = (MMCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MMLoadingCell *cell2 = (MMLoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    return cell;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        if(indexPath.row < 9 && self.movies.count !=0)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MMCustomCell" owner:nil options:nil] objectAtIndex:0]
            ;
            NSDictionary *data = [self.movies objectAtIndex:(indexPath.section * 9) + indexPath.row];
            cell.titleLabel.text = [data objectForKey:@"name"];
            //cell.timeLabel.hidden = NO;
            cell.timeLabel.text =[NSString stringWithFormat:@"%@ - %@",[data objectForKey:@"start_time"], [data objectForKey:@"end_time"]];
            [cell.iconImageView setImage:[UIImage imageNamed:[data objectForKey:@"channel"]]];
            [cell.ratingimageView setImage:[UIImage imageNamed:[data objectForKey:@"rating"]]];
        }
        else if(indexPath.row == 9 || self.movies.count == 0)
        {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"MMLoadingCell" owner:nil options:nil] objectAtIndex:0]
            ;
            [cell2.activityIndicator startAnimating];
            return cell2;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"homeToDetailsSegue" sender:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.movies objectAtIndex:(indexPath.section * 9) + indexPath.row] forKey:@"currentMovie"];
    [defaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Web Service Call
-(void) resultFromCall:(NSMutableDictionary *)result
{
    NSLog(@"results: %@",[result objectForKey:@"results"]);
    [self.movies  addObjectsFromArray:[result objectForKey:@"results"]];

    [self.homeView.tableView reloadData];
    self.offset = self.offset + ((NSArray *)[result objectForKey:@"results"]).count - 1;
    NSLog(@"offset:%d",self.offset) ;
    //NSLog(@"count :%d",((NSArray *)[result objectForKey:@"results"]).count);
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

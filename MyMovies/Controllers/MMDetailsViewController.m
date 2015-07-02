//
//  MMDetailsViewController.m
//  MyMovies
//
//  Created by Mary Alexis Solis on 7/2/15.
//  Copyright (c) 2015 Mary Alexis Solis. All rights reserved.
//

#import "MMDetailsViewController.h"

@interface MMDetailsViewController ()

@end

@implementation MMDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MMDetails" owner:self options:nil] firstObject];
    [self.view addSubview:self.detailsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [defaults objectForKey:@"currentMovie"];
    self.detailsView.headerTitleLabel.text = [data objectForKey:@"name"];
    self.detailsView.titleLabel.text = [data objectForKey:@"name"];
    self.detailsView.timeLabel.text= [NSString stringWithFormat:@"%@ - %@",[data objectForKey:@"start_time"], [data objectForKey:@"end_time"]];
    //self.detailsView.summaryLabel.text = [data objectForKey:@"channel"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

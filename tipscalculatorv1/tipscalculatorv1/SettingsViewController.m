//
//  SettingsViewController.m
//  tipscalculatorv1
//
//  Created by Ramasamy Dayanand on 9/20/15.
//  Copyright (c) 2015 Ramasamy Dayanand. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipsControl;

- (IBAction)onDefaultTipChange:(id)sender;
+ (int) getSavedDefaultPercent;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.defaultTipsControl setSelectedSegmentIndex:[[self class] getSavedDefaultPercent]];
    // Do any additional setup after loading the view from its nib.
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

     + (int) getSavedDefaultPercent{
         NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
         int savedDefaultPercentIndex = [nsUserDefaults integerForKey: @"tips_app_default_percent_index"];
         return savedDefaultPercentIndex;
     }

- (IBAction)onDefaultTipChange:(id)sender {
    NSArray *tipsPercentArray = @[@(0.1),@(0.15),@(0.2)];
    
    float selectedPercent = [tipsPercentArray[self.defaultTipsControl.selectedSegmentIndex] floatValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger: self.defaultTipsControl.selectedSegmentIndex forKey:@"tips_app_default_percent_index"];
    [defaults synchronize];
    

    NSLog(@"default percent saved : %d ", [[self class] getSavedDefaultPercent]);
}
@end

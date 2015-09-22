//
//  TipsViewController.m
//  tipscalculatorv1
//
//  Created by Ramasamy Dayanand on 9/19/15.
//  Copyright (c) 2015 Ramasamy Dayanand. All rights reserved.
//

#import "TipsViewController.h"
#import "SettingsViewController.h"

@interface TipsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipsPercentageField;
- (IBAction)onTap:(id)sender;
- (void)updateTipAndTotal;
- (void)onSettingsButton;

@end

@implementation TipsViewController

@synthesize currentLocale;

//- (void) dealloc
//{
//    [currentLocale release];
//    [super dealloc];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Tip Calculator";
        self.currentLocale = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
//        self.tipLabel.text = self.currentLocale;
//        self.totalLabel.text = [NSString stringWithFormat:@"%@00",self.currentLocale];
    }
    
    return self;
}

+ (int) getSavedDefaultPercent{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    int savedDefaultPercentIndex = [nsUserDefaults integerForKey: @"tips_app_default_percent_index"];
    if(savedDefaultPercentIndex == Nil){
        savedDefaultPercentIndex = 0;
    }
    return savedDefaultPercentIndex;
}

+(float) getSavedBillAmount{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *savedDate = [nsUserDefaults objectForKey:@"tips_app_last_saved_date"];
    if(savedDate == Nil){
        return 0.00;
    }
    
    NSDate *now = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorianCalendar
                                    components:unitFlags
                                    fromDate:savedDate
                                    toDate:now
                                    options:0];
//  [gregorianCalendar release];
    int minuteDiff = [components minute];
    if(minuteDiff < 10)
        return [nsUserDefaults floatForKey:@"tips_app_last_saved_bill_amount"];
    else{
        [nsUserDefaults setObject:Nil forKey:@"tips_app_last_saved_bill_amount"];
    }
    return 0.00;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    [self.billTextField becomeFirstResponder];
    
//    [self.tipsPercentageField setSelectedSegmentIndex:[[self class] getSavedDefaultPercent]];
//    NSLog(@"default %d", [[self class] getSavedDefaultPercent]);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tipsPercentageField setSelectedSegmentIndex:[[self class] getSavedDefaultPercent]];
    float billAmount = [[self class] getSavedBillAmount];
    if(billAmount != 0.00){
        [self.billTextField setText:[NSString stringWithFormat:@"%0.2f",billAmount]];
        [self updateTipAndTotal];
    }
//    self.tipLabel.text = [NSString stringWithFormat:@"%@%0.2f",currencySymbol,tipAmount];
//    self.totalLabel.text = [NSString stringWithFormat:@"%@%0.2f",currencySymbol, totalAmount];
    NSLog(@"view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    [nsUserDefaults setObject:[NSDate date] forKey: @"tips_app_last_saved_date"];
    NSLog(@"here ");

    [nsUserDefaults setFloat:[self.billTextField.text floatValue] forKey:@"tips_app_last_saved_bill_amount"];
    
    [nsUserDefaults synchronize];
//    NSLog([nsUserDefaults objectForKey:@"tips_app_last_saved_date"]);
    
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateTipAndTotal];
}

- (void)updateTipAndTotal {
    
    float billAmount = [self.billTextField.text floatValue];
    NSArray *tipPercentageArray = @[@(0.1),@(0.15),@(0.2)];
    float tipAmount = [tipPercentageArray[self.tipsPercentageField.selectedSegmentIndex] floatValue] * billAmount;
    float totalAmount = billAmount + tipAmount;
    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    NSLog(@"Currency Symbol");
    NSLog(self.currentLocale);
    self.tipLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale,tipAmount];
//    [NSString stringWithFormat:@"%@%0.2f",self.currentLocale,tipAmount];
    self.totalLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale, totalAmount];
}
-(void)onSettingsButton{
    
    NSLog(@"onSettings");
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];

}
    

@end

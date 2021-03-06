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
-(void)buttonClick:(id)target;
@property (weak, nonatomic) IBOutlet UIScrollView *tipsScroller;

@end

@implementation TipsViewController

@synthesize currentLocale;
@synthesize totalAmount;
@synthesize currentAnimatedTotal;

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
        [self.tipsScroller setBackgroundColor:[UIColor blackColor]];
        [self.tipsScroller setCanCancelContentTouches:NO];
        self.tipsScroller.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.tipsScroller.clipsToBounds = YES; // default is NO, we want to restrict drawing within our scrollview
        self.tipsScroller.scrollEnabled = YES;
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
    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [one setTag:0];
    UIButton *two = [[UIButton alloc] initWithFrame:CGRectMake(0, 35, 200, 30)];
    [two setTag:1];
    two.backgroundColor = [UIColor redColor];
    UIButton *three = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, 200, 30)];
    [three  setTag:2];
    three.backgroundColor = [UIColor redColor];

    [self.tipsScroller addSubview:one];
    [self.tipsScroller addSubview:two];
    [self.tipsScroller addSubview:three];

    NSArray *subviews = [self.tipsScroller subviews];

    for(UIButton *uiButton in subviews){
        [uiButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        uiButton.backgroundColor = [UIColor whiteColor];
        [uiButton.layer setBorderWidth:3.0];
        [uiButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tipsPercentageField setSelectedSegmentIndex:[[self class] getSavedDefaultPercent]];
    float billAmount = [[self class] getSavedBillAmount];
    if(billAmount != 0.00){
        [self.billTextField setText:[NSString stringWithFormat:@"%0.2f",billAmount]];
        [self updateTipAndTotal];
    }



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
    self.totalAmount = totalAmount;
    self.currentAnimatedTotal = 0.00;
    self.tipLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale,tipAmount];
    self.totalLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale, 0.00];
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

    NSArray *subviews = [self.tipsScroller subviews];

    float b = billAmount * 0.1;
    int i = 0;
    for (UIButton *uiButton in subviews){
        if(i<3){
            float tipVal = [tipPercentageArray[i] floatValue] * billAmount;
            int tipPct = (int)([tipPercentageArray[i] floatValue] * 100);
            NSString *amnt = [NSString localizedStringWithFormat:@"Tip @ %d %%  %@ %.2f", tipPct, self.currentLocale, tipVal];

            [uiButton setTitle:amnt forState: UIControlStateNormal];
            [uiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            i++;
        }
    }

}
-(void)onSettingsButton{
    
    NSLog(@"onSettings");
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];

}

-(void)buttonClick:(id)target{
    UIButton *uiButton = (UIButton *) target;
    int tag = [target tag];
    [self.tipsPercentageField setSelectedSegmentIndex: tag];
    [self updateTipAndTotal];
    NSLog(@"label Tapped");
}

- (void)timerFired:(NSTimer *)timer {
    float currentTotal = self.currentAnimatedTotal;
    float finalTotal = self.totalAmount;
    
    if(currentTotal + 10.00 < totalAmount){
        self.totalLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale, currentTotal + 10.00];
        self.currentAnimatedTotal = currentTotal + 10.00;
        NSLog(self.totalLabel.text);
    }
    else{
        self.totalLabel.text = [NSString localizedStringWithFormat:@"%@ %.2f", self.currentLocale, totalAmount];
        [timer invalidate];
    }
}




@end

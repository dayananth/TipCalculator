//
//  TipsViewController.h
//  tipscalculatorv1
//
//  Created by Ramasamy Dayanand on 9/19/15.
//  Copyright (c) 2015 Ramasamy Dayanand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsViewController : UIViewController{
    NSString *currentLocale;
    float totalAmount;
    float currentAnimatedTotal;
}
@property (retain) NSString *currentLocale;
@property  float totalAmount;
@property  float currentAnimatedTotal;

@end

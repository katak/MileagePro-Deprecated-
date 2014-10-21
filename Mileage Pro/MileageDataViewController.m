//
//  MileageDataViewController.m
//  Mileage Pro
//
//  Created by Kris Kata on 10/10/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import "MileageDataViewController.h"
#import "MileageDataModel.h"

@interface MileageDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *gallonsPurchased;
@property (weak, nonatomic) IBOutlet UITextField *odometerReading;
@property (weak, nonatomic) IBOutlet UITextField *totalCost;

@end

@implementation MileageDataViewController

- (IBAction)saveDataPoint:(id)sender
{
//    [self.model addDataPointWithGallonsPurchased:[self.gallonsPurchased.text floatValue]
//                                 odometerReading:[self.odometerReading.text intValue]
//                                       totalCost:[self.totalCost.text floatValue]];
    
    self.gallonsPurchased.text = @"";
    self.odometerReading.text = @"";
    self.totalCost.text = @"";
}

// hide keyboard if not focused on text field
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.gallonsPurchased setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.odometerReading setKeyboardType:UIKeyboardTypeNumberPad];
    [self.totalCost setKeyboardType:UIKeyboardTypeDecimalPad];
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

//
//  ViewController.m
//  Mileage Pro
//
//  Created by Kris Kata on 10/8/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import "MileageDataDetailViewController.h"

@interface MileageDataDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *distanceSinceLastFill;
@property (weak, nonatomic) IBOutlet UILabel *gallonsPurchased;
@property (weak, nonatomic) IBOutlet UILabel *odometerReading;
@property (weak, nonatomic) IBOutlet UILabel *pricePerGallon;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;

@end

@implementation MileageDataDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.distanceSinceLastFill.text = [NSString stringWithFormat:@"%d", self.dataDistanceSinceLastFill];
    self.gallonsPurchased.text = [NSString stringWithFormat:@"%.3f", self.dataGallonsPurchased];
    self.odometerReading.text = [NSString stringWithFormat:@"%d", self.dataOdometerReading];
    self.pricePerGallon.text = [NSString stringWithFormat:@"%.3f", self.dataPricePerGallon];
    self.totalCost.text = [NSString stringWithFormat:@"$%.2f", self.dataTotalCost];
}

@end

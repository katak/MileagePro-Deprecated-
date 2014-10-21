//
//  ViewController.h
//  Mileage Pro
//
//  Created by Kris Kata on 10/8/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MileageDataDetailViewController : UIViewController

@property (nonatomic) int dataDistanceSinceLastFill;
@property (nonatomic) float dataGallonsPurchased;
@property (nonatomic) int dataOdometerReading;
@property (nonatomic) float dataPricePerGallon;
@property (nonatomic) float dataTotalCost;

@end


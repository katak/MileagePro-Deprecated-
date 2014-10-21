//
//  MileageDataPointModel.m
//  Mileage Pro
//
//  Created by Kris Kata on 10/14/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import "MileageDataPointModel.h"

@implementation MileageDataPointModel

- (id)initWithOdometerReading:(NSInteger)odometerReading gallonsPurchased:(CGFloat)gallonsPurchased totalCost:(CGFloat)totalCost
{
    self = [super init];
    if (self)
    {
        _date = [NSDate date];
        _odometerReading = odometerReading;
        _gallonsPurchased = gallonsPurchased;
        _totalCost = totalCost;
//        _pricePerGallon = calculatePricePerGallon();
//        _distanceSinceLastFill = calculateDistanceSinceLastFill();
//        _uniqueId = fillInIdAfterDataPointIsSavedToServer(); // necessary?
    }
    return self;
}

@end

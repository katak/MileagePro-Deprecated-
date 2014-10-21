//
//  MileageDataPointModel.h
//  Mileage Pro
//
//  Created by Kris Kata on 10/14/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MileageDataPointModel : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger uniqueId;   // "id"
@property (nonatomic) NSInteger distanceSinceLastFill;
@property (nonatomic) NSInteger odometerReading;
@property (nonatomic) CGFloat gallonsPurchased;
@property (nonatomic) CGFloat pricePerGallon;
@property (nonatomic) CGFloat totalCost;

- (id)initWithOdometerReading:(NSInteger)odometerReading gallonsPurchased:(CGFloat)gallonsPurchased totalCost:(CGFloat)totalCost;
@end

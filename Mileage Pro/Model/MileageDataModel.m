//
//  MileageDataModel.m
//  Mileage Pro
//
//  Created by Kris Kata on 10/10/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import "MileageDataModel.h"

@implementation MileageDataModel

- (float)pricePerGallonWithTotalCost:(float)totalCost andGallonsPurchased:(float)gallonsPurchased
{
    float price = 0.0f;
    
    if (totalCost > 0.0f && gallonsPurchased > 0.0f){
        price = totalCost / gallonsPurchased;
    }
    
    return price;
}

//- (int)distanceSinceLastFill:(int)currentOdometerReading
//{
//    NSArray *mileageLog = [self.dataPoints valueForKeyPath:@"OdometerReading"];
//    int delta = 0;
//    
//    int latestEntry = [[mileageLog lastObject] intValue];
//    if (latestEntry < currentOdometerReading){
//        delta = currentOdometerReading - latestEntry;
//    }
//        
//    return delta;
//}

- (NSString *)formatDateFromJsonDate:(NSString *)rawDateString
{
    NSDate *date = [self convertDateFromMilliseconds:rawDateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    return [formatter stringFromDate:date];
}

- (NSDate *)convertDateFromMilliseconds:(NSString *)dateContainingMillis
{
    long long millis = 0;
    if ([dateContainingMillis length]){
        //    convert "/Date(1413222121507)/" -> "1413222121.507"
        NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
        NSArray *splitString = [dateContainingMillis componentsSeparatedByCharactersInSet:delimiters];
        long long seconds = [[splitString objectAtIndex:1] longLongValue];
        millis = seconds / 1000.0;
    }
    return [NSDate dateWithTimeIntervalSince1970:millis];
}

@end

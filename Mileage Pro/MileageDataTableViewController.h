//
//  MileageDataTableViewController.h
//  Mileage Pro
//
//  Created by Kris Kata on 10/8/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MileageDataTableViewController : UITableViewController <NSURLSessionDelegate>
@property (nonatomic, strong) NSMutableArray *dataPoints;
@end

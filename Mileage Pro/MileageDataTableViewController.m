//
//  MileageDataTableViewController.m
//  Mileage Pro
//
//  Created by Kris Kata on 10/8/14.
//  Copyright (c) 2014 illlillilliliil. All rights reserved.
//

#import "MileageDataTableViewController.h"
#import "MileageDataDetailViewController.h"
#import "MileageDataViewController.h"
#import "MileageDataPointModel.h"

//@interface MileageDataTableViewController ()
//@property (nonatomic, strong) MileageDataModel *model;
//@end

@implementation MileageDataTableViewController

NSURLSession *session;
@synthesize dataPoints = _dataPoints;

- (NSMutableArray *)dataPoints
{
    if(_dataPoints == nil){
        _dataPoints = [[NSMutableArray alloc] init];
    }
    return _dataPoints;
}

- (void)setDataPoints:(NSMutableArray *)dataPoints
{
    _dataPoints = dataPoints;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshTable" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    session = [NSURLSession sharedSession];
//    if (self.model == nil){
//        self.model = [[MileageDataModel alloc] init];
//    }
}

- (void)fetchDataPoints
{
//    if (self.model == nil){
//        self.model = [[MileageDataModel alloc] init];
//    }
//    self.dataPoints = self.model.dataPoints;
    [self.tableView reloadData];
}

//- (void)refreshTable:(NSNotification *)notification
//{
//    self.dataPoints = self.model.dataPoints;
//    if (self.dataPoints != nil){
//        [self.tableView reloadData];
//    }
//    NSLog(@"Table refreshed");
//}

#pragma mark - WebAPI

- (void)getData
{
    NSString *jsonUrlString = [NSString stringWithFormat:@"https://mileagepro.azurewebsites.net/MileageDataPoint/GetJsonData"];
    NSURL *url = [NSURL URLWithString:jsonUrlString];
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    
    NSMutableArray *dataPoints = [propertyListResults valueForKeyPath:@"data"];
    NSLog(@"%@", dataPoints);
    
    for (id dataPoint in dataPoints){
        NSInteger *uniqueId = [[dataPoint valueForKeyPath:@"Id"] integerValue];
        NSDate *date = [dataPoint valueForKeyPath:@"Date"]; // format date
        NSInteger distanceSinceLastFill = [dataPoint valueForKeyPath:@"DistanceSinceLastFill"];
        NSInteger odometerReading = [[dataPoint valueForKeyPath:@"OdometerReading"] integerValue];
        CGFloat gallonsPurchased = [[dataPoint valueForKeyPath:@"GallonsPurchased"] floatValue];
        CGFloat pricePerGallon = [[dataPoint valueForKeyPath:@"PricePerGallon"] floatValue];
        CGFloat totalCost = [[dataPoint valueForKeyPath:@"TotalCost"] floatValue];
        
        MileageDataPointModel *model = [[MileageDataPointModel alloc] initWithOdometerReading:odometerReading gallonsPurchased:gallonsPurchased totalCost:totalCost];
        [self.dataPoints addObject:model];
    }
    [self.tableView reloadData];
    
//    self.dataPoints = dataPoints;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
//    NSLog(@"Notification fired");
    
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://mileagepro.azurewebsites.net/MileageDataPoint/GetJsonData"]
    //                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //
    //        NSArray *dataPoints = [json valueForKeyPath:@"data"];
    //        NSLog(@"%@", dataPoints);
    //        self.dataPoints = dataPoints;
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    //        NSLog(@"Notification fired");
    //    }];
    //    [dataTask resume];
}

- (void)addDataPointWithGallonsPurchased:(float)gallonsPurchased odometerReading:(int)odometerReading totalCost:(float)totalCost
{
    
    // when sending date to server, use this:
    unsigned long long time=(([[NSDate date] timeIntervalSince1970])*1000);
    NSString *dateTimeTosend= [NSString stringWithFormat:@"/Date(%lld)/",time];
    
    int change = 1;//[self distanceSinceLastFill:odometerReading];
    
    float pricePerGallon =  0.0f;//[self pricePerGallonWithTotalCost:totalCost andGallonsPurchased:gallonsPurchased];
    
    NSDictionary *jsonDataPoint = @{
                                    @"Date":dateTimeTosend,
                                    @"OdometerReading":[NSString stringWithFormat:@"%d", odometerReading],
                                    @"GallonsPurchased":[NSString stringWithFormat:@"%.3f", gallonsPurchased],
                                    @"TotalCost":[NSString stringWithFormat:@"%.2f", totalCost],
                                    @"DistanceSinceLastFill":[NSString stringWithFormat:@"%d",change],
                                    @"PricePerGallon":[NSString stringWithFormat:@"%.3f", pricePerGallon]
                                    };
    
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:jsonDataPoint])
    {
        NSURL *url = [NSURL URLWithString:@"https://mileagepro.azurewebsites.net/api/MileageDataPointApi"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        //TODO: unsure if both of these are needed
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // Serialize the dictionary
        NSError *error = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:jsonDataPoint options:kNilOptions error:&error];
        
        if (!error){
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:json   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // TODO: dismiss viewcontroller
                //                NSLog(@"%@",response);
                [self fetchDataPoints];
            }];
            
            [uploadTask resume];
        }
    }
}

- (void)removeDataPointAtIndex:(int)index
{
    int uniqueId = [[self.dataPoints[index] valueForKeyPath:@"Id"] intValue];
    
    NSString *urlString = [NSString stringWithFormat:@"https://mileagepro.azurewebsites.net/api/MileageDataPointApi/%d", uniqueId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",response);
        [self.dataPoints removeObjectAtIndex:index];
        [self fetchDataPoints];
    }];
    
    [dataTask resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Mileage Data Point";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    MileageDataPointModel *dataPoint = self.dataPoints[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",dataPoint.odometerReading];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", dataPoint.date];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataPoints removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

#pragma mark - Navigation

- (void)prepareViewController:(MileageDataDetailViewController *)vc toDisplayMileageData:(NSDictionary *)data {
    vc.dataDistanceSinceLastFill = [[data valueForKeyPath:@"DistanceSinceLastFill"] intValue];
    vc.dataGallonsPurchased = [[data valueForKeyPath:@"GallonsPurchased"] floatValue];
    vc.dataOdometerReading = [[data valueForKeyPath:@"OdometerReading"] intValue];
    vc.dataPricePerGallon = [[data valueForKeyPath:@"PricePerGallon"] floatValue];
    vc.dataTotalCost = [[data valueForKeyPath:@"TotalCost"] floatValue];
    
//    vc.title = [self.model formatDateFromJsonDate:[data valueForKeyPath:@"Date"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Info"]){
                if ([segue.destinationViewController isKindOfClass:[MileageDataDetailViewController class]]){
                    [self prepareViewController:segue.destinationViewController toDisplayMileageData:self.dataPoints[indexPath.row]];
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"Add Data Point"]){
        if([segue.destinationViewController isKindOfClass:[MileageDataViewController class]]){
//            MileageDataViewController *mdvc = (MileageDataViewController *) segue.destinationViewController;
//            mdvc.model = self.model;
        }
    }
}

@end

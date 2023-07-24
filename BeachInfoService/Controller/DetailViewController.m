//
//  DetailViewController.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "DetailViewController.h"
#import "ServiceManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDataWithCompletion:^(NSMutableDictionary * result) {
        NSLog(@"%@", result);
    }];
}

- (void)fetchDataWithCompletion:(void (^)(NSMutableDictionary * result))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"20230724" forKey:@"base_date"];
    [params setObject:@"1230" forKey:@"base_time"];
    [params setObject:@"308" forKey:@"beach_num"];
    [params setObject:@"JSON" forKey:@"dataType"];
    [[ServiceManager new] requestWithParam:params endpoint:GetUltraSrtFcstBeach completion:^(NSData * data) {
        if (data) {
            NSString * returnData;
            @try
            {
                returnData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            @catch (NSException *exception)
            {
                NSLog(@"Http Request Exception [Response] :: %@", exception);
            }
            completion([NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        } else {
            NSLog(@"failed to connect");
            completion(nil);
        }
    }];
}

@end

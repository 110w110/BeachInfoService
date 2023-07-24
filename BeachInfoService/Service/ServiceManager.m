//
//  ServiceManager.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "ServiceManager.h"

@interface ServiceManager ()

- (NSString *)getEndpoint:(BeachInfoAPI)endpoint;

@end

@implementation ServiceManager {
    NSString * _serviceKey;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _serviceKey = @"Hd3XyBQRp1S%2BDtqgquxgSDsKM29vbWjolVHP2s6jVZv7KDUm%2FNiosWHuu3TIclOWN1GfvMX6H5wTVyXTlGWZbQ%3D%3D";
    }
    return self;
}

- (NSString *)getEndpoint:(BeachInfoAPI)endpoint {
    switch(endpoint) {
        case GetTwBuoyBeach:
            return @"/getTwBuoyBeach";
        case GetUltraSrtFcstBeach:
            return @"/getUltraSrtFcstBeach";
        case GetTideInfoBeach:
            return @"/getTideInfoBeach";
        case GetSunInfoBeach:
            return @"/getSunInfoBeach";
        case GetVilageFcstBeach:
            return @"/getVilageFcstBeach";
        default:
            return @"/";
    }
}

- (void)requestWithParam:(NSMutableDictionary *)params endpoint:(BeachInfoAPI)endpoint completion:(void (^)(NSData * data))completion {
    [params setObject:_serviceKey forKey:@"serviceKey"];

    NSString *url = [NSString stringWithFormat:@"https://apis.data.go.kr/1360000/BeachInfoservice%@?", [self getEndpoint:endpoint]];
    if (params != nil && params.count > 0){
        
        // [for 문을 돌면서 순차적으로 key , value 확인 실시]
        for (NSString *keyData in params.allKeys){
            NSString *valueData = [NSString stringWithFormat:@"%@" , params[keyData]];
            
            // [주소 포맷 수행 실시]
            url = [url stringByAppendingString:keyData];
            url = [url stringByAppendingString:@"="];
            url = [url stringByAppendingString:valueData];
            url = [url stringByAppendingString:@"&"];
        }
        
        url = [url substringToIndex:url.length - 1];
    }
    
    // [http 통신 Request 선언]
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    // [http 통신 메소드 지정]
    [urlRequest setHTTPMethod:@"GET"];
    
    // [http 통신 Content-Type 설정]
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // [NSURLSession 생성 실시]
    NSURLSession *session = [NSURLSession sharedSession];
    
    // [NSURLSessionDataTask http 통신 요청 처리]
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // [응답 결과]
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        // [리턴 데이터 선언]
        NSString * returnData = @"";
        
        // [에러 체크]
        if (error != nil){
            
            @try
            {
                returnData = error.localizedDescription;
            }
            @catch (NSException *exception)
            {
                NSLog(@"Http Request Exception [Error] :: %@", exception);
            }
            
            // [콜백 반환]
            NSLog(@"%@", returnData);
            completion(nil);
        } else {
            // [상태 코드 확인]
            if(httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300) {
                
                // [콜백 반환]
                NSLog(@"%@", returnData);
                completion(data);
            }
            else {
                // [상태 코드 에러]
                returnData = [returnData stringByAppendingString:@"State Code Error : "];
                returnData = [returnData stringByAppendingString:[@(httpResponse.statusCode) stringValue]];
                returnData = [returnData stringByAppendingString:@" : "];
                returnData = [returnData stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                
                // [콜백 반환]
                completion(nil);
            }
        }
    }];
    [dataTask resume];
}

@end

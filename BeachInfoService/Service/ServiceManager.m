//
//  ServiceManager.m
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import "ServiceManager.h"

@implementation ServiceManager
//?serviceKey=Hd3XyBQRp1S%2BDtqgquxgSDsKM29vbWjolVHP2s6jVZv7KDUm%2FNiosWHuu3TIclOWN1GfvMX6H5wTVyXTlGWZbQ%3D%3D
//base_date=20230724
//base_time=1230
//beach_num=308
//dataType=JSON
- (void)request {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Hd3XyBQRp1S%2BDtqgquxgSDsKM29vbWjolVHP2s6jVZv7KDUm%2FNiosWHuu3TIclOWN1GfvMX6H5wTVyXTlGWZbQ%3D%3D" forKey:@"serviceKey"];
    [params setObject:@"20230724" forKey:@"base_date"];
    [params setObject:@"1230" forKey:@"base_time"];
    [params setObject:@"308" forKey:@"beach_num"];
    [params setObject:@"JSON" forKey:@"dataType"];
    
    NSString *url = @"https://apis.data.go.kr/1360000/BeachInfoservice/getUltraSrtFcstBeach?";
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
        NSLog(@"%@",data);
        // [응답 결과]
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        // [Response Header 확인]
        NSDictionary *headerDictionary = [httpResponse allHeaderFields];
        printf("\n");
        printf("==================================== \n");
        printf("[ViewController >> getHttpCallBack() :: HTTP 통신 Response Header 확인] \n");
        printf("[headerDictionary :: %s] \n", headerDictionary.description.UTF8String);
        printf("==================================== \n");
        printf("\n");
        
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
            return;
        } else {
            // [상태 코드 확인]
            if(httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300) {
                
                @try
                {
                    returnData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                @catch (NSException *exception)
                {
                    NSLog(@"Http Request Exception [Response] :: %@", exception);
                }
                
                // [콜백 반환]
                NSLog(@"%@", returnData);
                return;
            }
            else {
                // [상태 코드 에러]
                returnData = [returnData stringByAppendingString:@"State Code Error : "];
                returnData = [returnData stringByAppendingString:[@(httpResponse.statusCode) stringValue]];
                returnData = [returnData stringByAppendingString:@" : "];
                returnData = [returnData stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                
                // [콜백 반환]
                NSLog(@"%@", returnData);
                return;
            }
        }
    }];
    [dataTask resume];
}

@end

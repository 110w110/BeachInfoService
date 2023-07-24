//
//  DetailViewController.h
//  BeachInfoService
//
//  Created by 한태희 on 2023/07/24.
//

#import <UIKit/UIKit.h>

@class Beach;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Beach * beach;

@end

NS_ASSUME_NONNULL_END

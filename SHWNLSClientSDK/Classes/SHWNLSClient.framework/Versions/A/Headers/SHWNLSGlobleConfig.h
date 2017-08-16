//
//  SHWNLSGlobleConfig.h
//  Pods
//
//  Created by Yang Yang on 2017/8/10.
//
//

#import <Foundation/Foundation.h>

@interface SHWNLSGlobleConfig : NSObject

+ (void)setAppKey:(NSString *)appKey;
+ (void)setAppSecret:(NSString *)appSecret;
+ (NSString *)getAppKey;
+ (NSString *)getAppSecret;

@end

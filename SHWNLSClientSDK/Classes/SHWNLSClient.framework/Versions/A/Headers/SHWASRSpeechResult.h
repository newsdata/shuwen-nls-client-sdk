//
//  SHWASRSpeechResult.h
//  Pods
//
//  Created by Yang Yang on 2017/8/9.
//
//

#import <Foundation/Foundation.h>

@interface SHWASRSpeechResult : NSObject
@property (nonatomic, readonly, copy)NSString *text;
+ (instancetype)initWithText:(NSString *)text;
@end

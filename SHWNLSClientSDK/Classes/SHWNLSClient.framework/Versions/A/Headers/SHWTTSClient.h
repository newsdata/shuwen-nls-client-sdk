//
//  SHWTTSClient.h
//  SHWNLSClient
//
//  Created by Yang Yang on 2017/8/7.
//  Copyright © 2017年 xinhuazhiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHWNLSPublicHeader.h"

@class SHWTTSClient;

@protocol SHWTTSClientDelegate <NSObject>
    
/*!
 Called when the tts procedure returns audio data.
 */
- (void)ttsClient:(SHWTTSClient *)ttsClient didReceiveAudio:(NSData *)audioData sequence:(int)sequence;

@optional

/*!
    Called when the tts procedure completes successfully.
 */
- (void)ttsClientDidFinish:(SHWTTSClient *)ttsClient;

/*!
    Called when the tts procedure has an error.
 */
- (void)ttsClient:(SHWTTSClient *)ttsClient didFailWithError:(NSError *)error;

@end


@interface SHWTTSClient : NSObject
+ (instancetype)initWithDelegate:(id<SHWTTSClientDelegate>)delegate;
/**
 * @prama language, pass nil will use default language en-US
 */
- (void)tts:(NSString *)text language:(NSString *)language;
- (void)cancel;
@end

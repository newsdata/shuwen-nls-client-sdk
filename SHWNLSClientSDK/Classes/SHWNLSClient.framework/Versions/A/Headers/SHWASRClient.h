//
//  SHWASRClient.h
//  SHWNLSClient
//
//  Created by Yang Yang on 2017/8/7.
//  Copyright © 2017年 xinhuazhiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SHWASRSpeechResult.h"
#import "SHWNLSPublicHeader.h"

@class SHWASRClient;

@protocol SHWASRClientDelegate <NSObject>
/*!
 Called when the asr procedure returns a custom application response.
 */
- (void)asrClient:(SHWASRClient *)asrClient didReceiveServiceResponse:(SHWASRSpeechResult *)result;
@optional
/*!
    Called when the asr procedure starts recording audio.
 */
- (void)asrClientDidBeginRecording:(SHWASRClient *)asrClient;

/*!
    Called when the asr procedure stops recording audio.
 */
- (void)asrClientDidFinishRecording:(SHWASRClient *)asrClient;

/*!
 Called when the asr procedure stops recording audio.
 */
- (void)asrClientDidFinishRecognizing:(SHWASRClient *)asrClient;

/*!
    Called when the asr procedure has an error.
 */
- (void)asrClient:(SHWASRClient *)asrClient didFailWithError:(NSError *)error;
@end

@interface SHWASRClient : NSObject
+ (instancetype)initWithDelegate:(id<SHWASRClientDelegate>)delegate;
- (void)beginRecordWithLanguage:(NSString *)language;
- (void)finishRecordAndRecognize;
- (BOOL)isRecording;
- (void)cancel;
@end

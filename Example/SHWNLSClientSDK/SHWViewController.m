//
//  HViewController.m
//  SHWNLSClientSDK
//
//  Created by yayang on 08/09/2017.
//  Copyright (c) 2017 yayang. All rights reserved.
//

#import "SHWViewController.h"
#import <SHWNLSClient/SHWNLSClient.h>

@interface SHWViewController ()<SHWASRClientDelegate, SHWTTSClientDelegate>
@property (nonatomic, strong)SHWASRClient *asrClient;
@property (nonatomic, strong)SHWTTSClient *ttsClient;
@end

@implementation SHWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.asrClient = [SHWASRClient initWithDelegate:self];
    self.ttsClient = [SHWTTSClient initWithDelegate:self];
    [self.asrClient beginRecord];
//    [self.asrClient finishRecordAndRecognize];
//    [self.ttsClient tts:@"test" language:nil];
}

#pragma mark - asr delegate
- (void)asrClientDidBeginRecording:(SHWASRClient *)asrClient {
    NSLog(@"---Begin Recording.");
}

/*!
 Called when the asr procedure stops recording audio.
 */
- (void)asrClientDidFinishRecording:(SHWASRClient *)asrClient {
    NSLog(@"---Finish Recording.");
}

/*!
 Called when the asr procedure returns a custom application response.
 {data:{recognitionText:@""}, code:200}。
 */
- (void)asrClient:(SHWASRClient *)asrClient didReceiveServiceResponse:(SHWASRSpeechResult *)result {
    NSMutableString *asrText = [@"\nResult: <<" mutableCopy];
    if(result!=nil && result.text!=nil && [result.text isKindOfClass:[NSString class]]){
        [asrText appendString:result.text];
    }
    [asrText appendString:@">>"];
    NSLog(@"%@", asrText);
}

/*!
 Called when the asr procedure has an error.
 */
- (void)asrClient:(SHWASRClient *)asrClient didFailWithError:(NSError *)error {
    
}

#pragma mark - tts delegate
- (void)ttsClient:(SHWTTSClient *)ttsClient didReceiveAudio:(NSData *)audioData sequence:(int)sequence {
    NSLog(@"audio length: %ld", audioData.length);
}

/*!
 Called when the tts procedure completes successfully.
 */
- (void)ttsClientDidFinish:(SHWTTSClient *)ttsClient {
    NSLog(@"tts finish");
}

/*!
 Called when the tts procedure has an error.
 */
- (void)ttsClient:(SHWTTSClient *)ttsClient didFailWithError:(NSError *)error {
    
}
@end

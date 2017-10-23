//
//  SHWNLSViewController.m
//  SHWNLSClient
//
//  Created by yayang on 08/09/2017.
//  Copyright (c) 2017 yayang. All rights reserved.
//

#import "SHWNLSViewController.h"
#import <SHWNLSClient/SHWNLSClient.h>
#import <AVFoundation/AVFoundation.h>
#import "SHWNLSConstantHeader.h"

#define TEST_APPKEY     @""
#define TEST_APPSECRET  @""
 
#define TEST_CN_APPKEY     @""
#define TEST_CN_APPSECRET  @""

@interface SHWNLSViewController ()<SHWASRClientDelegate, SHWTTSClientDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong)SHWASRClient *asrClient;
@property (nonatomic, strong)SHWTTSClient *ttsClient;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *startASRBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopASRBtn;
@property (weak, nonatomic) IBOutlet UIButton *ttsBtn;
@property (nonatomic, strong)AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *useRecordBtn;

@property (nonatomic, strong)NSMutableArray *audioArray;

@property (nonatomic, copy)NSString *defaultText;
@property (nonatomic, copy)NSString *defaultLanguage;
@property (nonatomic)long begin;
@end

@implementation SHWNLSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultText = CN_TEXT;
    self.defaultLanguage = SHW_NLS_LANGUAGE_US;
    [SHWNLSGlobleConfig setAppKey:TEST_CN_APPKEY];
    [SHWNLSGlobleConfig setAppSecret:TEST_CN_APPSECRET];

//    self.defaultText = FINE_TEXT;
//    [SHWNLSGlobleConfig setAppKey:TEST_APPKEY];
//    [SHWNLSGlobleConfig setAppSecret:TEST_APPSECRET];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    self.stopASRBtn.hidden = YES;
    self.textField.scrollEnabled = YES;
    
    self.textField.text = [NSString stringWithFormat:@"%@", self.defaultText];
    
    self.view.tintColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:0.8];
    self.textField.textColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:0.8];
    self.textField.backgroundColor = [UIColor colorWithRed:27/255.0 green:177/255.0 blue:214/255.0 alpha:0.8];
    self.view.backgroundColor = [UIColor colorWithRed:34/255.0 green:202/255.0 blue:254/255.0 alpha:0.8];
    
    self.textField.alwaysBounceVertical = YES;
    
    self.asrClient = [SHWASRClient initWithDelegate:self];
    self.ttsClient = [SHWTTSClient initWithDelegate:self];
}

- (void)hideKeyBoard:(UITapGestureRecognizer*)tap {
    [self.textField resignFirstResponder];
}

- (IBAction)startASRClicked:(id)sender {
    [self cancelAll];
    [self beginASR];
}

- (IBAction)stopASRClicked:(id)sender {
    [self.asrClient finishRecordAndRecognize];
    self.startASRBtn.hidden = NO;
    self.stopASRBtn.hidden = YES;
}

- (IBAction)ttsRequest:(id)sender {
    self.begin = (long)([[NSDate date] timeIntervalSince1970]*1000);
    [self cancelAll];
    @synchronized (self) {
        [self.audioArray removeAllObjects];
        self.audioArray = [NSMutableArray array];
    }
    
    if(self.textField.text.length<=0) {
        self.textField.text = self.defaultText;
    }
    
    NSString *ttsText = self.textField.text;

    [self.ttsClient tts:ttsText language:self.defaultLanguage];
}

#pragma mark - asr delegate
- (void)asrClientDidBeginRecording:(SHWASRClient *)asrClient {
    self.textField.text = @"---Begin Recording.";
}

- (void)asrClientDidFinishRecording:(SHWASRClient *)asrClient {
    NSLog(@"Controller didFinishRecording");
    self.textField.text = [self.textField.text stringByAppendingString:@"\n---Finish Recording."];
    self.startASRBtn.hidden = NO;
    self.stopASRBtn.hidden = YES;
}

- (void)asrClientDidFinishRecognizing:(SHWASRClient *)asrClient {
    NSLog(@"Controller didFinishRecognizing");
    self.textField.text = [self.textField.text stringByAppendingString:@"\n---Finish Recognition."];
}

- (IBAction)cancelClicked:(id)sender {
    [self cancelAll];
}

- (void)beginASR {
    [self.asrClient beginRecordWithLanguage:self.defaultLanguage];
    self.textField.text = @"";
    self.startASRBtn.hidden = YES;
    self.stopASRBtn.hidden = NO;
}

- (void)cancelAll {
    [self.asrClient cancel];
    [self.ttsClient cancel];
    [self.audioArray removeAllObjects];
    [self.player stop];
    self.startASRBtn.hidden = NO;
    self.stopASRBtn.hidden = YES;
}

- (IBAction)useRecordClicked:(id)sender {
    [self cancelAll];
    [self beginASR];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample2_12s" ofType:@"mp3"];
    NSData *audioData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)asrClient:(SHWASRClient *)asrClient didReceiveServiceResponse:(SHWASRSpeechResult *)result {
    NSMutableString *asrText = [@"\nResult: <<" mutableCopy];
    if(result!=nil && result.text!=nil && [result.text isKindOfClass:[NSString class]]) {
        [asrText appendString:result.text];
    }
    [asrText appendString:@">>"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textField.text = [self.textField.text==nil?@"":self.textField.text stringByAppendingString:asrText];
    });
}

- (void)asrClient:(SHWASRClient *)asrClient didFailWithError:(NSError *)error {
    NSLog(@"Controller didFailWithError");
    self.textField.text = [self.textField.text stringByAppendingFormat:@"\n---Failed with error, %@.", error.userInfo[NSLocalizedDescriptionKey]];
}


#pragma mark - tts delegate
- (void)ttsClient:(SHWTTSClient *)ttsClient didReceiveAudio:(NSData *)audioData sequence:(int)sequence {
    if(audioData.length>0) {
        NSError *error;
        @synchronized (self) {
            if(!self.player.isPlaying && self.audioArray.count==0) {
                self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
                self.player.delegate = self;
                [self.player prepareToPlay];
//                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingFormat:@"/%d.mp3", sequence];
//                NSLog(@"%@", path);
//                [audioData writeToFile:path atomically:YES];
                if(error) {
                    NSLog(@"error : %@",error);
                }else {
                    [self.player play];
                    if(self.begin) {
                        long end = (long)([[NSDate date] timeIntervalSince1970]*1000);
                        NSLog(@"first duration %ld", end - self.begin);
                        self.begin = 0;
                    }
                }
            }else {
                [self.audioArray addObject:audioData];
            }
        }
    }
}

- (void)ttsClientDidFinish:(SHWTTSClient *)ttsClient {
    NSLog(@"ttsClientDidFinish");
}

- (void)ttsClient:(SHWTTSClient *)ttsClient didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSError *error;
    @synchronized (self) {
        if(self.audioArray.count>0){
            self.player = [[AVAudioPlayer alloc] initWithData:self.audioArray.firstObject error:&error];
            [self.audioArray removeObjectAtIndex:0];
            [self.player prepareToPlay];
            self.player.delegate =self;
            if(error){
                NSLog(@"error : %@",error);
            }else {
                [self.player play];
            }
        }
    }
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
@end

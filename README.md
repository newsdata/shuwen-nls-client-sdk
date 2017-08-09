# 边牧 iOS SDK 接入指南(v0.1.0)

This project is a public SDK for who want analyse user behaviors.
Deploy target : iOS 8.0.

## 1 如何接入

### 1.1 在机器上添加Pod仓库
在命令行输入并执行：
```bash
pod repo add frameworkplatform https://code.aliyun.com/xhzy-ios/frameworkplatform.git
```

### 1.2 在项目的 Podfile 中，添加如下依赖：

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://code.aliyun.com/xhzy-ios/frameworkplatform.git'

target 'YourProject' do
  pod 'SHW', '~> 1.0.8'
end
```

> 注: 以上 pod 版本号，请自行更新到最新版本

### 1.3 执行 `pod install`

## 2 Regist your app.
Get your AppKey in our web site.
appKey值可从新华智云接口人获取（网站建设中，目前请联系接口人）

## 3 How to use

### 3.1 ASR, 语音转文字
语音只支持麦克风录制，长度限制15s
```objective-c
@protocol SHWASRClientDelegate <NSObject>
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
    Called when the asr procedure returns a custom application response.
    {data:{recognitionText:@""}, code:200}。
 */
- (void)asrClient:(SHWASRClient *)asrClient didReceiveServiceResponse:(NSDictionary *)result;

/*!
    Called when the asr procedure has an error.
 */
- (void)asrClient:(SHWASRClient *)asrClient didFailWithError:(NSError *)error;
@end

@interface SHWASRClient : NSObject
+ (instancetype)initWithDelegate:(id<SHWASRClientDelegate>)delegate;
- (void)beginRecord;
- (void)finishRecordAndRecognize;
- (void)cancel;
@end
```


### 3.2 tts, 文字转语音
长度限制，暂定1000字。超过限制，将分次返回音频文件。
返回的音频文件格式为mp3
```objective-c
@protocol SHWTTSClientDelegate <NSObject>
@optional

/*!
    Called when the tts procedure returns audio data.
 */
- (void)ttsClient:(SHWTTSClient *)ttsClient didReceiveAudio:(NSData *)audioData sequence:(int)sequence;

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
 * @prama language, pass nil will use default language en_us
 */
- (void)tts:(NSString *)text language:(NSString *)language;
- (void)cancel;
@end

```


## 4 其它

- 由于 UTDID.framework 不支持 bitcode ，需要将 Build setting 下 Build Options 中的Enable Bitcode 至为 NO

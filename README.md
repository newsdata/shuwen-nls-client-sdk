# 边牧 iOS SDK 接入指南(v1.0.8)

自然语言服务SDK，目前用于英文和中文的ASR和TTS.

Deploy target : iOS 8.0.

## 1 如何接入

### 1.1 在项目的 Podfile 中，添加如下依赖：

```ruby
target 'YourProject' do
  pod 'SHWNLSClient', '~> 1.0.8'
end
```

### 1.2 更新安装

`pod update`
`pod install`

## 2 Regist your app.

Get your AppKey in our web site.
appKey值可从新华智云接口人获取（网站建设中，目前请联系接口人）

## 3 How to use

### 3.1 设置AppKey和AppSecret

```Objective-C
[SHWNLSGlobleConfig setAppKey:@“Your_APPKEY”];
[SHWNLSGlobleConfig setAppSecret:@“Your_APPSECRET”];
```

### 3.2 ASR, 语音转文字

语音只支持麦克风录制，长度限制```15s```。
delegate方法，最终都在主线程中回调。
>多次调用beginRecord，如果已经处于Recording状态，后面的调用无效。

language，英文传参数 "en-US"，中文传参数 "zh-CN"。

```Objective-C
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
 Called when the asr procedure stops recording audio.
 */
- (void)asrClientDidFinishRecognizing:(SHWASRClient *)asrClient;

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
- (void)beginRecordWithLanguage:(NSString *)language;
- (void)finishRecordAndRecognize;
- (BOOL)isRecording;
- (void)cancel;
@end
```


### 3.3 tts, 文字转语音

长度没有限制，ttsClient:didReceiveAudio:sequence:会多次返回音频文件。
返回的NSData音频格式为mp3。
delegate方法，最终都在主线程中回调。
>多次调用tts:language:，后一次会cancel前一次的请求。

language，英文传参数 "en-US"，中文传参数 "zh-CN"。

```Objective-C
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

项目使用了http协议，所以需要适配
在```Info.plist```中添加```NSAppTransportSecurity```类型```Dictionary```。
在```NSAppTransportSecurity```下添加```NSAllowsArbitraryLoads```类型```Boolean```,值设为```YES```。

项目需要使用麦克风，需要适配
在```Info.plist```中添加```Privacy - Microphone Usage Description```类型```NSString```。

## 5 错误码

|错误码|错误类型|
|---|---|
|0          |无错误|
| 1001      | 录音错误|
|1003    |   网络错误|
|1004     | 超时|
|1005|   用户取消|
|1006        | 鉴权错误|
|1007           |ASR错误|
|1008           |TTS错误|



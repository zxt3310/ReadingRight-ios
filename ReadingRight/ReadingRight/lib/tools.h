//
//  tools.h
//  TYSalePlatForm
//
//  Created by zhangxintao on 2019/5/7.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface REStaticObj : NSObject
@property id loginVC;
@property id coverVC;
+ (instancetype) sharedObj;
@end


@interface userInfo : NSObject <NSSecureCoding,NSCoding>
@property NSString *activeCode;
@property NSString *imei;
@property NSInteger lastUpdate;
@property NSString *exp;
@property NSInteger bgiId;

+ (instancetype)defalutUser;
- (void)save;
@end

@interface TYSaleCookieTool : NSObject

/**
 讲对应域名的存入cookie
 
 @param name key like 'token'
 @param value value
 @param domain 域名
 */
+ (void)saveCookieWithName:(NSString *)name Value:(NSString *)value domain:(NSString *)domain expire:(NSInteger)expire;

/**
 删除cookie
 
 @param name cookie的名字
 */
+ (void)deleteCookieWithName:(NSString *)name;

/**
获取cookie

@param name cookie的名字
@return 对应的cookie，可能为空
*/
+ (NSHTTPCookie *)cookieWithName:(NSString *)name;

@end

//微信支付 签名模型
@interface wechatPayRes : NSObject
@property NSString *partnerId;
@property NSString *prepayId;
@property NSString *nonceStr;
@property NSString *sign;
@property UInt32 timeStamp;
@property NSString *package;
@property NSString *out_trade_no;
@end

@interface NSString(ex)
+ (BOOL)isBlankString:(NSString *)str;
@end

UIViewController* topViewController(void);
UIViewController* _topViewController (UIViewController* vc);
NSString* stringOfNumber(NSInteger number);
NSString* stringOfDate(NSDate *date);
NSString* stringOfFloat(float number);
NSString* stringOfDouble(double number);
NSString* stringOfPercent(int number);
//md5
NSString * md5HexDigest(NSString *input);
//验证手机号
BOOL checkTelNumber(NSString *telNumber);
//验证身份证号
BOOL checkUserID(NSString *userID);
//判断银行卡号是否合法
BOOL isBankCard(NSString *cardNumber);
//获取今天的年月日星期
NSString* stringWithTodayDate(void);
//弹窗回调函数
typedef void(^callback)(void);
//弹窗提示
UIAlertController* alertInitWithTitle (NSString *title,NSString *message,NSString *confirm,NSString *cancel,callback callBack);
//授权同意回调函数
typedef void(^authorConfirmCallBack)(void);
//检查并请求相册授权
void requestPhotoLibraryStatus(authorConfirmCallBack confirm);

//获取手机cache目录下的文件
id jsonFromFile(NSString *fileName,NSString *type);
//检测资源目录
BOOL DataExist(void);

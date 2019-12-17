//
//  tools.m
//  TYSalePlatForm
//
//  Created by zhangxintao on 2019/5/7.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <Photos/Photos.h>
#import <AdSupport/AdSupport.h>

@implementation REStaticObj

+ (instancetype) sharedObj{
    static REStaticObj *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

@end

@implementation userInfo

static userInfo *usr;

+ (instancetype)defalutUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usr = [self loadLocal];
    });
    return usr;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

+ (id) loadLocal{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:LocalUser];
    if (data) {
        id obj;
        if (@available(iOS 11,*)) {
            obj = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:data error:nil];
        }else{
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        return obj;
    }else{
        return [[self alloc] init];
    }
}

- (void)save{
    NSData *data;
    if (@available(iOS 11,*)) {
        data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:nil];
    }else{
        data = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:LocalUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

//cookie
@implementation TYSaleCookieTool

+ (void)saveCookieWithName:(NSString *)name Value:(NSString *)value domain:(NSString *)domain expire:(NSInteger)expire{
    // 保存
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    // 取名
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    // 设值
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    // 存放目录
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    // 设置本地过期 不设置关掉app即清空
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:expire] forKey:NSHTTPCookieExpires];
    // 设值域名
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    // 生成cookie
    NSHTTPCookie *httpCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    // 存入仓库
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:httpCookie];
}

+ (void)deleteCookieWithName:(NSString *)name{
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStore.cookies) {
        if ([cookie.name isEqualToString:name]) {
            [cookieStore deleteCookie:cookie];
        }
    }
}

+ (NSHTTPCookie *)cookieWithName:(NSString *)name{
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStore.cookies) {
        if ([cookie.name isEqualToString:name]) {
            return cookie;
        }
    }
    return nil;
}

@end

@implementation wechatPayRes

@end

@implementation NSString(ex)

+ (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end

//查找控制器
UIViewController* topViewController() {
    UIViewController *resultVC;
    resultVC = _topViewController([[UIApplication sharedApplication].keyWindow rootViewController]);
    while (resultVC.presentedViewController) {
        resultVC = _topViewController(resultVC.presentedViewController);
    }
    return resultVC;
}

UIViewController* _topViewController (UIViewController* vc) {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return _topViewController([(UINavigationController *)vc topViewController]);
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return _topViewController([(UITabBarController *)vc selectedViewController]);
    } else {
        return vc;
    }
    return nil;
}

NSString *stringOfDate(NSDate *date){
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone localTimeZone];
    format.dateFormat = @"yyyy-MM-dd";
    return [format stringFromDate:date];
}

NSString* stringOfNumber(NSInteger number){
    return [NSString stringWithFormat:@"%ld",number];
}

NSString* stringOfFloat(float number){
    return [NSString stringWithFormat:@"%.2f",number];
}

NSString* stringOfDouble(double number){
    return [NSString stringWithFormat:@"%0.6f",number];
}

NSString* stringOfPercent(int number){
    return [NSString stringWithFormat:@"%d",number];
}

NSString* stringWithTodayDate(void){
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents *compoment = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger year = compoment.year;
    NSInteger month = compoment.month;
    NSInteger day = compoment.day;
    NSInteger week = compoment.weekday;
    
    NSArray *weekAry = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    return [NSString stringWithFormat:@"今天是%@年%@月%@日\n星期%@",stringOfNumber(year),stringOfNumber(month),stringOfNumber(day),weekAry[week-1]];
}

#pragma 提示弹窗
UIAlertController* alertInitWithTitle (NSString *title,NSString *message,NSString *confirm,NSString *cancel,callback callBack){
    UIAlertController *alertCtrol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        callBack();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:nil];
    [alertCtrol addAction:confirmAction];
    [alertCtrol addAction:cancelAction];
    return alertCtrol;
}

#pragma 正则匹配手机号
BOOL checkTelNumber(NSString *telNumber)
{
    NSString *pattern = @"^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

#pragma 正则验证身份证
BOOL checkUserID(NSString *userID)
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}


#pragma mark 判断银行卡号是否合法
BOOL isBankCard(NSString *cardNumber){
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}


NSString* md5HexDigest(NSString *input){
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];//%02意思是不足两位将用0补齐，如果多于两位则不影响,小写x表示输出小写，大写X表示输出大写
    }
    return ret;
}

#pragma mark 请求相册权限
void requestPhotoLibraryStatus(authorConfirmCallBack confirm){
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
            //已授权
        case PHAuthorizationStatusAuthorized:
            confirm();
            break;
            //由于某些原因被拒绝  比如家长控制
        case PHAuthorizationStatusRestricted:
            //[SVProgressHUD showInfoWithStatus:@"应用因特殊原因被禁止访问相册，请检查是否开启特殊模式"];
            break;
            //明确阻止
        case PHAuthorizationStatusDenied:
        {
            //弹出提示信息
            UIAlertController *alert = alertInitWithTitle(@"提示", @"无法获取相册权限",@"去设置",@"取消", ^{
                NSURL *url = nil;
                if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0f) {
                    url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                }
                if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                }
            });
            [topViewController() presentViewController:alert animated:YES completion:nil];
        }
            break;
            //还未请求过授权
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus statu){
                if (statu == PHAuthorizationStatusAuthorized) {
                    confirm();
                }else{
                    //弹出提示信息
                    UIAlertController *alert = alertInitWithTitle(@"提示", @"无法获取相册权限",@"去设置",@"取消", ^{
                        NSURL *url = nil;
                        if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0f) {
                            url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        }
                        if([[UIApplication sharedApplication] canOpenURL:url]){
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    });
                    [topViewController() presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
            break;
        default:
            break;
    }
}


id jsonFromFile(NSString *fileName,NSString *type){
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheDir = [cache stringByAppendingPathComponent:LocalDirectry];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    if ([type isEqualToString:@"image"]) {
        return fileData;
    }else{
        return [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
    }
}


BOOL DataExist(void){
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *unzipCache = [cache stringByAppendingPathComponent:@"content"];
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:unzipCache isDirectory:&isDirectory];
    return isExist && isDirectory;
}

//
//  ToolClass.m
//  DistributionQuery
//
//  Created by Macx on 16/11/10.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ToolClass.h"
#import<CommonCrypto/CommonDigest.h>
@implementation ToolClass

//#pragma mark --个人类型转换
//+(NSString*)myStype:(NSString*)str{
//    if ([str isEqualToString:@"1"]) {
//        return @"个人";
//    }else if ([str isEqualToString:@"2"]){
//        return @"企业";
//    }else {
//        return @"未认证";
//    }
//    
//}

+(NSString *)registTyple:(NSString*)str{
    NSMutableDictionary * dic =[NSMutableDictionary new];
//    [dic setObject:@"4497002900010001" forKey:@"个人"];
//    [dic setObject:@"4497002900010002" forKey:@"公司"];
    [dic setObject:@"4497002900020001" forKey:@"供应商"];
    [dic setObject:@"4497002900020002" forKey:@"采购商"];
    [dic setObject:@"4497002900020003" forKey:@"全部"];
   
    [dic setObject:@"4497002900010002" forKey:@"Company"];
    [dic setObject:@"4497002900010001" forKey:@"Personal"];
    
   

    [dic setObject:@"免费会员" forKey:@"free"];
    [dic setObject:@"vip会员" forKey:@"vip"];
    [dic setObject:@"金牌供应商" forKey:@"goldvip"];
    [dic setObject:@"4497003000020002" forKey:@"￥"];
    [dic setObject:@"4497003000020003" forKey:@"$"];
    [dic setObject:@"4497003000020004" forKey:@"€"];
    
    
    [dic setObject:@"Company" forKey:@"4497002900010002"];
    [dic setObject:@"Personal" forKey:@"4497002900010001"];
//    [dic setObject:@"个人" forKey:@"4497002900010001"];
//    [dic setObject:@"公司" forKey:@"4497002900010002"];
    [dic setObject:@"供应商" forKey:@"4497002900020001"];
    [dic setObject:@"采购商" forKey:@"4497002900020002"];
    [dic setObject:@"全部" forKey:@"4497002900020003"];
    
    [dic setObject:@"free" forKey:@"免费会员"];
    [dic setObject:@"vip" forKey:@"vip会员"];
    [dic setObject:@"goldvip" forKey:@"金牌供应商"];
    [dic setObject:@"￥" forKey:@"4497003000020002"];
    [dic setObject:@"$" forKey:@"4497003000020003"];
    [dic setObject:@"€" forKey:@"4497003000020004"];
    
  return  [dic objectForKey:str];
}

#pragma mark ---时间+天数
+(NSString*)timeAddDay:(NSString*)day{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *Date0 = [NSDate date];
    NSTimeInterval interval = 24*60*60;
    NSString *titleString = [dateFormatter stringFromDate:[Date0 initWithTimeInterval:interval*[day integerValue] sinceDate:Date0]];
    return titleString;
}





#pragma mark --获取验证码倒计时
+(void)timeDaoJiShi:(UIButton*)btn{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
+(NSString *)base64EncodedString:(NSString*)string;
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];;
    return [data base64EncodedStringWithOptions:0];
}
+(NSString*)base64Decode:(NSString *)string {
    //1.将base64编码后的字符串，解码成二进制数据
    //这里不能使用注释掉的方法转换成二进制,因为 string 就是已经编码过的字符串
    //NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    //2.返回解码的字符串
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}




#pragma mark --性别转换
+(NSString*)XingBieStr:(NSString*)xb{
    if ([xb isEqualToString:@"0"]) {
        return @"男";
    }else if ([xb isEqualToString:@"1"]){
        return @"女";
    }else{
        return nil;
    }
    
}

#pragma mark --判断是否登录（登录YES）
+(BOOL)isLogin{
    NSString * str =[NSUSE_DEFO objectForKey:API_Token];
    if (str==nil) {
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark --判断是不是ipad如果是返回YES
+(BOOL)isiPad{
    //// 768 1024
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark --适配高度
+(CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark --判断字符串是不是空
+(NSString*)isString:(id)str{
    NSString * string =[NSString stringWithFormat:@"%@",str];
    if (string==nil  || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        
       return @"";
    }else{
        return string;
    }
    
    
    return string;
}

#pragma mark --把登录返回的字典内容中nil转换成空字符串
+(NSMutableDictionary*)isDictionary:(NSDictionary*)dic{
    
    NSMutableArray * valueArr =[NSMutableArray new];
    NSMutableArray * keyArr =[NSMutableArray new];
    NSMutableDictionary * dicc =[NSMutableDictionary new];
    //遍历所有的键值
    for (NSString * value in [dic allValues]) {
        NSString * str = [NSString stringWithFormat:@"%@",value];
        NSString * str1 =[ToolClass isString:str];
        [valueArr addObject:str1];
    }
    //遍历所有的键名
    for (NSString * key in [dic allKeys]) {
        [keyArr addObject:key];
    }
    
    if (keyArr.count==valueArr.count) {
        
        for (int i =0; i<keyArr.count; i++) {
            [dicc setObject:valueArr[i] forKey:keyArr[i]];
        }
        return dicc;
    }else{
        [LCProgressHUD showMessage:@"键名键值对应不上，请联系开发人员"];
        return nil;
    }
}





#pragma mark --设置字符传不同的颜色 
+(NSMutableAttributedString *)attrStrFrom:(NSString *)titleStr intFond:(int)fond Color:(UIColor*)color numberStr:(NSString *)numberStr
{
    NSMutableAttributedString *arrString = [[NSMutableAttributedString alloc]initWithString:titleStr];
    // 设置前面几个字串的格式:红色 13.0f字号
    [arrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fond],NSForegroundColorAttributeName:color}range:[titleStr rangeOfString:numberStr]];
    
    return arrString;
}

#pragma mark --Label行间距设置
+(NSMutableAttributedString *)hangJianJuStr:(NSString*)str JuLi:(int)juli{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:juli];
     UIColor *color = [UIColor blackColor];
     NSAttributedString *string = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    return string;
}

#pragma mark -- 拨打电话
+(void)tellPhone:(NSString*)tell{
    //联系我们
    NSString *allString = [NSString stringWithFormat:@"tel:%@",tell];
    NSString*telUrl =[allString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

#pragma mark -  计算内容文本的高度方法
+ (CGFloat)HeightForText:(NSString *)text withSizeOfLabelFont:(CGFloat)font withWidthOfContent:(CGFloat)contentWidth
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = CGSizeMake(contentWidth, 2000);
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height;
}

#pragma mark -  计算字符串长度
+ (CGFloat)WidthForString:(NSString *)text withSizeOfFont:(CGFloat)font
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [text sizeWithAttributes:dict];
    return size.width;
}

#pragma mark -  json转换
+(id )getObjectFromJsonString:(NSString *)jsonString
{
    NSError *error = nil;
    if (jsonString) {
        id rev=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUnicodeStringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error==nil) {
            return rev;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

+(NSString *)getJsonStringFromObject:(id)object
{
    if ([NSJSONSerialization isValidJSONObject:object])
        
    {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    return nil;
}





#pragma mark --存储Plist文件
+(void)savePlist:(id)SaveDic name:(NSString*)plistName{
    
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name =[NSString stringWithFormat:@"%@.plist",plistName];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
    NSLog(@"输出路径%@",plistPath);
    [SaveDic writeToFile:plistPath atomically:YES];
    
    
}







#pragma mark --读取plist文件
+(NSMutableDictionary*)duquPlistWenJianPlistName:(NSString*)plistname{
    
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name =[NSString stringWithFormat:@"%@.plist",plistname];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
    // NSLog(@"输出路径%@",plistPath);
    //读取输出
    NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    // NSLog(@"write data is :%@",writeData);
    return writeData;
}
+(NSMutableArray*)duquArrayPlistWenJianPlistName:(NSString*)plistname{
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name =[NSString stringWithFormat:@"%@.plist",plistname];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
    // NSLog(@"输出路径%@",plistPath);
    //读取输出
    // NSMutableDictionary *writeData=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    // NSLog(@"write data is :%@",writeData);
    
    NSMutableArray *writeData =[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    return writeData;
    
}

#pragma mark --删除plist文件
+(void)deleagtePlistName:(NSString*)plistName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name =[NSString stringWithFormat:@"%@.plist",plistName];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:name];
    DeleteSingleFile(plistPath);
}


BOOL DeleteSingleFile(NSString *filePath){
    NSError *err = nil;
    
    if (nil == filePath) {
        return NO;
    }
    
    NSFileManager *appFileManager = [NSFileManager defaultManager];
    
    if (![appFileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    
    if (![appFileManager isDeletableFileAtPath:filePath]) {
        return NO;
    }
    
    return [appFileManager removeItemAtPath:filePath error:&err];
}

#pragma mark --获取本地时间
//获取当前时间
+(NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:[NSDate  date]];
    return dateTime;
}


#pragma mark --MD5加密
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}




+(UIButton*)imageViewNameStr:(NSString*)imageName{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    btn.adjustsImageWhenHighlighted=NO;
    btn.frame=CGRectMake(0, 0, 45, 30);
//    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    return btn;
}









#pragma mark --根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

#pragma mark --获取UUID
+(NSString*)getUUIDStr{
    
    NSString * uuidStr =[NSUSE_DEFO objectForKey:@"UUID"];
    if (uuidStr) {
        NSLog(@"输出uuid%@",uuidStr);
        return uuidStr;
    }else{
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [NSUSE_DEFO setObject:result forKey:@"UUID"];
        [NSUSE_DEFO synchronize];
        NSLog(@"输出uuid%@",result);
        return result;
    }
}
+(void)exitApplication {
//    WINDOW.alpha = 0;
//    WINDOW.frame = CGRectMake(0, WINDOW.bounds.size.width, 0, 0);
}
+(void)exitApplication2{
    exit(0);
}
#pragma mark --html解析
+(NSAttributedString * )HTML:(NSString*)string1
{
    NSString * htmlString = string1;
    NSAttributedString * attributedString =[[NSAttributedString alloc]initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    return attributedString;
}
#pragma mark --毫秒数转化为时间
+ (NSString *)ConvertStrToTime:(long long)timeStr

{
    //long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:timeStr/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//HH:mm:ss
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}


    
+(NSString*)quChuLaiStr:(NSString*)str{
    NSMutableDictionary * dicc =[NSMutableDictionary new];
    [dicc setObject:@"1" forKey:@"肿瘤会诊"];
    [dicc setObject:@"2" forKey:@"其它疑难杂症"];
    [dicc setObject:@"M" forKey:@"男"];
    [dicc setObject:@"F" forKey:@"女"];
    [dicc setObject:@"Y" forKey:@"有"];
    [dicc setObject:@"N" forKey:@"无"];
    
    return [dicc objectForKey:str];
    
}
    

@end

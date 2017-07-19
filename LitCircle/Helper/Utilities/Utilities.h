//
//  Utilities.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width height:(float)height;
+(void)showAlertView:(NSString *)title message:(NSString *)message withViewController:(UIViewController*)cntroller;
    
+ (BOOL)isValidEmailAddress:(NSString *)emailText;
+(NSString*)convertUTCdateToTime:(NSDate*)date;
+(NSString*)convertUTCdateToLocal:(NSDate*)date withFormate:(NSString*)formate;
+(CGFloat)getHeightOfString:(NSString *)string withWidht:(CGFloat)widht;
+(void)prefixLabel:(UITextField*)textfield;
    
+(void)showAlertView:(NSString *)title message:(NSString *)message;
    
+(NSString*)convertCommentUTCdateToTime:(NSDate*)date;
    
+ (NSString *)imageToNSString:(UIImage *)image;

+(NSString*)formatedDateFromString:(NSString*)date;

+ (CGFloat)getLabelHeight:(NSString*)text;

+ (NSString *)relativeDateStringForDate:(NSString *)timeStampFromJSON;
    
@end

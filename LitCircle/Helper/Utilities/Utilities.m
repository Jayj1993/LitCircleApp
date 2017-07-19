//
//  Utilities.m
//  LitCircle
//
//  Created by Afzal Sheikh on 12/13/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#import "Utilities.h"
#import "NSDate+Helper.h"
@implementation Utilities
    
    
+ (BOOL)isValidEmailAddress:(NSString *)emailText {
    NSString *emailRegEx =
    @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-"
    @"zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:emailText];
}

+(void)showAlertView:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles: nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification)
    {
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
}
    
+(void)showAlertView:(NSString *)title message:(NSString *)message withViewController:(UIViewController*)cntroller {
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title  message:message  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    [cntroller presentViewController:alertController animated:YES completion:nil];
}

+(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width height:(float)height {
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
    
+(NSString*)convertUTCdateToTime:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}
    
+(NSString*)convertCommentUTCdateToTime:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM. dd,yyyy -- hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}

+(NSString*)convertUTCdateToLocal:(NSDate*)date withFormate:(NSString*)formate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}

+(CGFloat)getHeightOfString:(NSString *)string withWidht:(CGFloat)widht {
    CGRect expectedLabelSize = [string boundingRectWithSize:CGSizeMake(widht, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} context:nil];
    return expectedLabelSize.size.height;
}
    
+(void)prefixLabel:(UITextField*)textfield {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textfield.frame.size.height)];
    leftView.backgroundColor = textfield.backgroundColor;
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}
    
+ (NSString *)imageToNSString:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (NSString *)relativeDateStringForDate:(NSString *)timeStampFromJSON {
    NSDate *date = [NSDate dateFromString:timeStampFromJSON];
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitSecond;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    if (components.year==1)
        return [NSString stringWithFormat:@"%ld yr", (long)components.year];
    else if (components.year > 0)
        return [NSString stringWithFormat:@"%ld yrs", (long)components.year];
    else if (components.month==1)
        return [NSString stringWithFormat:@"%ld month", (long)components.month];
    else if (components.month > 0)
        return [NSString stringWithFormat:@"%ld months", (long)components.month];
    else if (components.weekOfYear==1)
        return [NSString stringWithFormat:@"%ld week", (long)components.weekOfYear];
    else if (components.weekOfYear > 0)
        return [NSString stringWithFormat:@"%ld weeks", (long)components.weekOfYear];
    else if (components.day==1)
        return [NSString stringWithFormat:@"%ld day", (long)components.day];
    else if (components.day > 1)
        return [NSString stringWithFormat:@"%ld days", (long)components.day];
    else if (components.hour<24 && components.hour>0) {
            if (components.hour==1)
                return [NSString stringWithFormat:@"%ld hour", (long)components.hour];
            return [NSString stringWithFormat:@"%ld hours", (long)components.hour];
    }
    else if (components.minute<60 && components.minute>0){
        if (components.minute==1)
            return [NSString stringWithFormat:@"%ld minute", (long)components.minute];
        return [NSString stringWithFormat:@"%ld minutes", (long)components.minute];
    }
    else if (components.second>0)
        return [NSString stringWithFormat:@"%ld seconds", (long)components.second];
    else return [NSString stringWithFormat:@"%ld second", (long)components.second];
}

+(NSString*)formatedDateFromString:(NSString*)date {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSDate *currentDate = [dateFormater dateFromString:date];
    NSLog(@"currentDate: %@", currentDate);
    [dateFormater setDateFormat:@"EEEE, d MMMM yyyy"];
    NSString *convertedDateString = [dateFormater stringFromDate:currentDate];
    NSLog(@"convertedDateString: %@", convertedDateString);
    return convertedDateString;
}

+ (CGFloat)getLabelHeight:(NSString*)text {
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width-78, CGFLOAT_MAX);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                            context:context].size;
    return CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height)).height;
}

@end

//
//  YKAlarm.h
//  MiniGameAlarm
//
//  Created by Yeop Kim on 2014. 4. 22..
//  Copyright (c) 2014년 Seon Yeop Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKAlarm : NSObject <NSCoding>


// init
- (id)initWithFireDate:(NSDate *)date audioFileURL:(NSURL *)url identifier:(NSString *)str;


// Required
@property (nonatomic, strong) NSDate *fireDate;

@property (nonatomic, strong) NSURL *audioFileURL;

@property (nonatomic, strong) NSString *identifier;


// Optional
@property (nonatomic, strong) NSDictionary *userInfo;



/* UILocalNotification Info */

@property (nonatomic, strong) NSString *alertBody; // If this value is nill, UILocalNotification is not available.

@property (nonatomic, strong) NSString *alertAction;
@property (nonatomic, strong) NSString *soundName;


@end

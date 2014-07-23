//
//  YKAlarmSoundPlayer.h
//  MiniGameAlarm
//
//  Created by Yeop Kim on 2014. 4. 20..
//  Copyright (c) 2014년 Seon Yeop Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "YKAlarm.h"


@protocol YKAlarmCenterDelegate <NSObject>

- (void)didReceiveAlarm:(YKAlarm *)alarm;

@end


@interface YKAlarmCenter : NSObject


@property (nonatomic, weak) id<YKAlarmCenterDelegate> delegate;

@property (nonatomic, readonly) YKAlarm *nowPlayingAlarm;



+ (YKAlarmCenter *)sharedPlayer;

// Schedule Alarm
- (void)scheduleAlarm:(YKAlarm *)alarm;

// Cancel Scheduled Alarm
- (void)cancelAllAlarm;
- (void)cancelAlarmWithIdentifier:(NSString *)identifier;

// Play or Pause Alarm Sound
- (void)play;
- (void)pause;

// Return Alarm Objects
- (NSArray *)scheduledAlarmArray;
- (NSDictionary *)scheduledAlarmDictionary;  /*  objectForKey:(Alarm Identifier)  */

// Return Identifiers
- (NSArray *)alarmIdentifiers;

/*
Before your app is terminated, you need to cancel all alarm and save alarm objects.
*/

@end

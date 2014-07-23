//
//  YKAlarmSoundPlayer.m
//  MiniGameAlarm
//
//  Created by Yeop Kim on 2014. 4. 20..
//  Copyright (c) 2014년 Seon Yeop Kim. All rights reserved.
//

#import "YKAlarmCenter.h"


@interface YKAlarmCenter () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary   *alarmObjects;
@property (nonatomic, strong) NSMutableDictionary   *timerObjects;
@property (nonatomic, strong) NSMutableDictionary   *localnotiObjects;

@property (nonatomic, strong) NSMutableArray    *identifierStrings;

@property (nonatomic, strong) AVAudioPlayer *audioP;
@property (nonatomic, strong) NSString  *nowPlayingAlarmID;

@end


static YKAlarmCenter *player;


@implementation YKAlarmCenter

+ (id)sharedPlayer {
    
    if (player == nil) player = [[YKAlarmCenter alloc] init];
    
    return player;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.alarmObjects = [NSMutableDictionary dictionaryWithCapacity:0];
        self.timerObjects = [NSMutableDictionary dictionaryWithCapacity:0];
        self.localnotiObjects = [NSMutableDictionary dictionaryWithCapacity:0];
        self.identifierStrings = [NSMutableArray arrayWithCapacity:0];
        
        self.nowPlayingAlarmID = nil;
        _nowPlayingAlarm = nil;
    }
    return self;
}

- (void)scheduleAlarm:(YKAlarm *)alarm {
    
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.timeZone = [NSTimeZone defaultTimeZone];
    localNoti.fireDate = alarm.fireDate;
    localNoti.alertBody = alarm.alertBody;
    localNoti.alertAction = alarm.alertAction;
    localNoti.soundName = alarm.soundName;
    localNoti.userInfo = alarm.userInfo;
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:alarm.fireDate interval:0.0f target:self selector:@selector(didReceiveTimer:) userInfo:alarm repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    [self.alarmObjects setObject:alarm forKey:alarm.identifier];
    [self.localnotiObjects setObject:localNoti forKey:alarm.identifier];
    [self.timerObjects setObject:timer forKey:alarm.identifier];
    
    [self.identifierStrings addObject:alarm.identifier];
}

- (void)cancelAllAlarm {
    
    [self.audioP stop];
    self.audioP.currentTime = 0.0f;
    self.nowPlayingAlarmID = nil;
    _nowPlayingAlarm = nil;
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    
    for (int i = 0; i < self.identifierStrings.count; i++) {
        UILocalNotification *localNoti = [self.localnotiObjects objectForKey:[self.identifierStrings objectAtIndex:i]];
        [[UIApplication sharedApplication] cancelLocalNotification:localNoti];
    }
    for (int i = 0; i < self.identifierStrings.count; i++) {
        NSTimer *timer = [self.timerObjects objectForKey:[self.identifierStrings objectAtIndex:i]];
        [timer invalidate];
    }
    
    self.alarmObjects = [NSMutableDictionary dictionaryWithCapacity:0];
    self.localnotiObjects = [NSMutableDictionary dictionaryWithCapacity:0];
    self.timerObjects = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.identifierStrings = [NSMutableArray arrayWithCapacity:0];
}

- (void)cancelAlarmWithIdentifier:(NSString *)identifier {
    
    if ([self.nowPlayingAlarmID isEqualToString:identifier]) {
        
        [self.audioP stop];
        self.audioP.currentTime = 0.0f;
        self.nowPlayingAlarmID = nil;
        _nowPlayingAlarm = nil;
        
        [[AVAudioSession sharedInstance] setActive:NO];
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:[self.localnotiObjects objectForKey:identifier]];
    [[self.timerObjects objectForKey:identifier] invalidate];
    
    [self.alarmObjects removeObjectForKey:identifier];
    [self.localnotiObjects removeObjectForKey:identifier];
    [self.timerObjects removeObjectForKey:identifier];
    
    for (int i = 0; i < self.identifierStrings.count; i++) {
        
        if ([[self.identifierStrings objectAtIndex:i] isEqualToString:identifier]) [self.identifierStrings removeObjectAtIndex:i];
    }
}

- (void)play {
    
    [self.audioP play];
}

- (void)pause {
    
    [self.audioP pause];
}

- (NSArray *)scheduledAlarmArray {
    
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];

    for (int i = 0; i < self.identifierStrings.count; i++) {
        
        [muArr addObject:[self.identifierStrings objectAtIndex:i]];
    }
    
    return muArr;
}

- (NSDictionary *)scheduledAlarmDictionary {
    
    return self.alarmObjects;
}

- (NSArray *)alarmIdentifiers {
    
    return self.identifierStrings;
}


#pragma mark didReceiveTimer

- (void)didReceiveTimer:(id)sender {
    
    NSLog(@"didReceiveTimer");
    
    NSTimer *timer = (NSTimer *)sender;
    YKAlarm *alarm = timer.userInfo;
    
    self.nowPlayingAlarmID = alarm.identifier;
    _nowPlayingAlarm = alarm;
    
    [[AVAudioSession sharedInstance] setActive:YES];
    
    self.audioP = [[AVAudioPlayer alloc] initWithContentsOfURL:alarm.audioFileURL error:nil];
    self.audioP.delegate = self;
    [self.audioP play];
    
    [self.delegate didReceiveAlarm:alarm];
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"audioPlayerDidFinishPlaying");
    
    [player play];
}

@end

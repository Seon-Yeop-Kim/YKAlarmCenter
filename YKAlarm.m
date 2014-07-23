//
//  YKAlarm.m
//  MiniGameAlarm
//
//  Created by Yeop Kim on 2014. 4. 22..
//  Copyright (c) 2014년 Seon Yeop Kim. All rights reserved.
//

#import "YKAlarm.h"

@implementation YKAlarm

- (id)initWithFireDate:(NSDate *)date audioFileURL:(NSURL *)url identifier:(NSString *)str {
    
    self = [super init];
    if (self) {
        
        self.fireDate = date;
        self.audioFileURL = url;
        self.identifier = str;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.fireDate forKey:@"fireDate"];
    [aCoder encodeObject:self.audioFileURL forKey:@"audioFileURL"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
    [aCoder encodeObject:self.alertBody forKey:@"alertBody"];
    [aCoder encodeObject:self.alertAction forKey:@"alertAction"];
    [aCoder encodeObject:self.soundName forKey:@"soundName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.fireDate = [aDecoder decodeObjectForKey:@"fireDate"];
        self.audioFileURL = [aDecoder decodeObjectForKey:@"audioFileURL"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
        self.alertBody = [aDecoder decodeObjectForKey:@"alertBody"];
        self.alertAction = [aDecoder decodeObjectForKey:@"alertAction"];
        self.soundName = [aDecoder decodeObjectForKey:@"soundName"];
    }
    return self;
}

@end

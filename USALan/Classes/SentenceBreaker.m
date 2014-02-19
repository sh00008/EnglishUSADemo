//
//  LessonLoader.m
//  USALan
//
//  Created by JiaLi on 14-2-4.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "SentenceBreaker.h"

@implementation SentenceBreaker

+ (BOOL)isPunct:(wint_t)_wc {
    if (_wc == 0x0020 || _wc == 0x3000 || _wc == 0x0009 || _wc == 0x000d || _wc == 0x000a) {
        return YES;
    }
    if (_wc >= 32 && _wc <= 47)
        return YES;
    
    if (_wc >= 58 && _wc <= 64)
        return YES;
    
    if (_wc >= 128 && _wc <= 254) {
        return YES;
    }
    
	NSString *stringflag = SENTENCE_FLAG;
	NSString *strSentenceFlag = [[NSString alloc] initWithString:stringflag];
	NSString *ch = @", ";
	NSArray *array = [strSentenceFlag componentsSeparatedByString:ch];
	for (NSInteger i = 0; i < [array count]; i++) {
		NSString *chPuct = [array objectAtIndex:i];
		if (_wc == [chPuct intValue]) {
			return YES;
		}
	}
    
    if ([SentenceBreaker isSpecial:_wc]) {
        return YES;
    }
	return NO;
}

+ (BOOL)isSpecial:(wint_t)_wc {
	NSString *strSentenceFlag = [[NSString alloc] initWithFormat:@"%@", SPECIAL_FLAG];
	wint_t ch;
	for (int i = 0; i < strSentenceFlag.length; i++) {
		ch = [strSentenceFlag characterAtIndex:i];
		if (_wc == ch) {
			return YES;
		}
	}
	return NO;
}

@end

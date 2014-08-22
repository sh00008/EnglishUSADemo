//
//  FilePathGet.m
//  USALan
//
//  Created by JiaLi on 14-8-23.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "FilePathGet.h"

@implementation FilePathGet

+ (NSString*)getTextFileContent:(NSString*)imagePath;
{
    NSString* lessonContent = nil;
    if (IS_SAME) {
        NSRange range = [imagePath rangeOfString:@"Image" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            NSString* filePath = [imagePath substringToIndex:range.location];
            NSString* fileName = [imagePath substringFromIndex:(range.location+range.length+1)];
            NSString* newPath = [NSString stringWithFormat:@"%@Text%@.txt", filePath, fileName];
            lessonContent =  [NSString stringWithContentsOfFile:newPath encoding: NSASCIIStringEncoding error:nil];
        }
        
    } else {
        NSRange range = [imagePath rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            NSString* filename = [imagePath substringFromIndex:range.location+1];
            NSRange headerrange = [filename rangeOfString:HEADERSTRING];
            if (headerrange.location != NSNotFound) {
                NSString* textName = [filename substringFromIndex:headerrange.location+headerrange.length];
                NSRange chRange = [textName rangeOfString:@"-"];
                if (chRange.location != NSNotFound) {
                    NSInteger first = [[textName substringToIndex:chRange.location] integerValue];
                    NSInteger second = [[textName substringFromIndex:(chRange.location+1)] integerValue];
                    NSString* textfilename = [NSString stringWithFormat:@"%d-%d", first - RLATIONOFFSETX, second + RLATIONOFFSETY];
                    NSString* textPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"%@", @"/Data/Text/"];
                    
                    lessonContent =  [NSString stringWithContentsOfFile:[textPath stringByAppendingFormat:@"%@.txt", textfilename] encoding: NSASCIIStringEncoding error:nil];
                }
            }
        }
        
    }
    return lessonContent;
        
}

+ (NSString*)getmp3FilePath:(NSString*)src
{
    NSString* path = nil;
    if (IS_SAME) {
        NSRange range = [src rangeOfString:@"Image" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            NSString* filePath = [src substringToIndex:range.location];
            NSString* fileName = [src substringFromIndex:(range.location+range.length+1)];
            NSString* newPath = [NSString stringWithFormat:@"%@Voice%@.mp3", filePath, fileName];
            path = newPath;
        }
    } else {
        NSRange range = [src rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            NSString* filename = [src substringFromIndex:range.location+1];
            NSRange headerrange = [filename rangeOfString:HEADERSTRING];
            if (headerrange.location != NSNotFound) {
                NSString* textName = [filename substringFromIndex:headerrange.location+headerrange.length];
                NSRange chRange = [textName rangeOfString:@"-"];
                if (chRange.location != NSNotFound) {
                    NSInteger first = [[textName substringToIndex:chRange.location] integerValue];
                    NSInteger second = [[textName substringFromIndex:(chRange.location+1)] integerValue];
                    NSString* textfilename = [NSString stringWithFormat:@"%d-%d", first - RLATIONOFFSETX, second + RLATIONOFFSETY];
                    NSString* textPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"%@", @"/Data/Voice/"];
                    NSString* path = [textPath stringByAppendingFormat:@"%@.mp3", textfilename];
                    path = path;
                    
                }
            }
        }
        
    }
    return path;
}
@end

//
//  FilePathGet.h
//  USALan
//
//  Created by JiaLi on 14-8-23.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePathGet : NSObject
+ (NSString*)getTextFileContent:(NSString*)src;
+ (NSString*)getmp3FilePath:(NSString*)src;
@end

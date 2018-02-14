//
//  QNADataManager.h
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNADataManager : NSObject

- (void)requestJSONData:(void (^)(NSString *title, NSArray *results))completion;

@end

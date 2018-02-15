//
//  QNADataManager.h
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAPhotoRecord.h"

typedef void (^blockPhotoDataReady) (NSData* data);

@interface QNADataManager : NSObject

- (void)requestJSONData:(NSInteger) nStart limit: (NSInteger) nLimit completion:(void (^)(NSString *title, NSArray *results))completion;
- (void)requestJSONData:(void (^)(NSString *title, NSArray *results))completion;
- (void)startDownloadImage:(QNAPhotoRecord *)photoRecord photoDataReady:(blockPhotoDataReady) block;

@end

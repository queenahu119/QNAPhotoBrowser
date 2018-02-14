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

- (void)requestJSONData:(void (^)(NSString *title, NSArray *results))completion;
- (void)startDownloadImage:(QNAPhotoRecord *)photoRecord photoDataReady:(blockPhotoDataReady) block;

@end

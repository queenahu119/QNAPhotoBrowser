//
//  QNADataManager.m
//  QNAPhotoBrowser
//
//  Created by QueenaHuang on 14/2/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

#import "QNADataManager.h"
#import "QNAPhotoRecord.h"

static NSString *QNAJsonURLString = @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json";

@implementation QNADataManager


- (void)requestJSONData:(void (^)(NSString *title, NSArray *results))completion {

    NSString *urlAsString = [NSString stringWithFormat:@"%@", QNAJsonURLString];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            // show error message
        } else {
            NSError *error = nil;

            NSDictionary *dic = [self photoDataFromJSON:data error:&error];

            completion([dic objectForKey:@"title"], [dic objectForKey:@"rows"]);
        }
    }];
}


- (NSDictionary *)photoDataFromJSON:(NSData *)objectNotation error:(NSError **)error
{

    NSError *localError = nil;
    NSString *jsonString = [[NSString alloc] initWithData:objectNotation encoding:NSISOLatin1StringEncoding];
    NSData *jsonDataUtf8 = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:jsonDataUtf8 options:0 error:&localError];

    if (localError != nil) {
        *error = localError;
        NSLog(@"%@", localError.localizedDescription);
        return nil;
    }

    NSMutableArray *groups = [[NSMutableArray alloc] init];

    NSString *titleString = [self verifyNullValue:[parsedObject valueForKey:@"title"]];
    NSArray *photoArray = [parsedObject valueForKey:@"rows"];

    for (NSDictionary *recordDic in photoArray) {
        QNAPhotoRecord *record = [[QNAPhotoRecord alloc] init];

        record.photoName = [self verifyNullValue:[recordDic valueForKey:@"title"]];
        record.photoURLString = [self verifyNullValue:[recordDic valueForKey:@"imageHref"]];
        record.photoDescription = [self verifyNullValue:[recordDic valueForKey:@"description"]];

        [groups addObject:record];
    }

    NSDictionary *result = @{@"title" : titleString,
                             @"rows": groups};

    return result;
}

/*! Replace <NSNull> with nil.
 * \returns NSString or nil
 */
- (NSString*)verifyNullValue:(id)value {
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return value;
    }
}

@end

//
//  HttpAdapter.h
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 24..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpAdapter : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSString *urlString;
    NSURL *url;
    NSMutableURLRequest *request;
    NSURLResponse *response;
    NSURLConnection *connection;
    NSMutableData *data;
    NSMutableData *receivedData;
    NSString *dataString;
    BOOL isFinishLoading;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLResponse *response;

- (id)initWithUrl:(NSString *)restUrlString;

- (NSMutableArray *)GetJsonDataWithUrl:(NSString *)restUrlString;
- (NSMutableArray *)SyncSendPostDataWithUrl:(NSString *)restUrlString postData:(NSDictionary *)postDict;
- (NSMutableArray *)SyncSendPostImageDataWithUrl:(NSString *)restUrlString file:(NSData *)file filename:(NSString *)filename;
- (BOOL)AsyncSendPostDataWithUrl:(NSString *)restUrlString postData:(NSDictionary *)postDict;

- (NSString *)base64EncodingWithLineLength:(unsigned int)lineLength data:(NSData *)imgData;

@end

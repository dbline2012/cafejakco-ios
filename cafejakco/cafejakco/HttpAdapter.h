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
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLResponse *response;

- (id)initWithUrl:(NSString *)restUrlString;

- (NSMutableArray *)GetJsonDataWithUrl:(NSString *)restUrlString;

- (BOOL)SendPostDataWithUrl:(NSString *)restUrlString postData:(NSDictionary *)postDict;

- (NSString *)base64EncodingWithLineLength:(unsigned int)lineLength data:(NSData *)imgData;

@end

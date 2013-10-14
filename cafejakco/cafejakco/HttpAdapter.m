//
//  HttpAdapter.m
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 24..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "HttpAdapter.h"

@implementation HttpAdapter

@synthesize urlString = _urlString;
@synthesize receivedData = _receivedData;
@synthesize response = _response;

- (id)initWithUrl:(NSString *)restUrlString;
{
    self = [super init];
    if (self) {
        // Custom initialization
        urlString = restUrlString;
    }
    return self;
}

- (NSMutableArray *)GetJsonDataWithUrl:(NSString *)restUrlString
{
    url = [NSURL URLWithString:restUrlString];
    data = [NSMutableData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return array;
}

- (NSString *)SyncSendPostDataWithUrl:(NSString *)restUrlString postData:(NSDictionary *)postDict
{
    isFinishLoading = FALSE;
    url = [NSURL URLWithString:restUrlString];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    /* setBody */
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString* contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* body = [NSMutableData data];
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"%@", jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    /* Authorization */
//    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [postDict objectForKey:@"username"], [postDict objectForKey:@"password"]];
//    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
//    
//    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64EncodingWithLineLength:80 data:authData]];
//    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    receivedData = [NSMutableData data];
    
    NSURLResponse *response;
    NSError *err;
    NSMutableData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if (responseData)
    {
        NSLog(@"[HttpAdapter/SyncSendPostDataWithUrl] connection ok : %@", responseString);
        return responseString;
    }
    return @"fail";
}

- (BOOL)AsyncSendPostDataWithUrl:(NSString *)restUrlString postData:(NSDictionary *)postDict
{
    isFinishLoading = FALSE;
    url = [NSURL URLWithString:restUrlString];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    /* setBody */
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString* contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* body = [NSMutableData data];
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"%@", jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    /* Authorization */
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [postDict objectForKey:@"username"], [postDict objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [self base64EncodingWithLineLength:80 data:authData]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    receivedData = [NSMutableData data];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection)
    {
        NSLog(@"[HttpAdapter/AsyncSendPostDataWithUrl] connection ok");
        return YES;
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    [receivedData setLength:0];
    self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData
{
    [receivedData appendData:aData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"[HttpAdapter/didFailWithError] Error : %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"[HttpAdapter/connectionDidFinishLoading] %@", dataString);
    isFinishLoading = TRUE;
    
}

- (NSString *)base64EncodingWithLineLength:(unsigned int)lineLength data:(NSData *)imgData
{
    static const char *encodingTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const unsigned char *bytes = [imgData bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[imgData length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [imgData length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    short i = 0;
    short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES ) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;

        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendFormat:@"%c",'='];
        
        ixtext += 3;
        charsonline += 4;
        
        if( lineLength > 0 ) {
            if (charsonline >= lineLength) {
                charsonline = 0;
                [result appendString:@"\n"];
            }
        }
    }
    return result;
}

@end

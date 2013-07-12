#import "DNSSDUtils.h"


NSString * const DNSSDErrorDomain = @"DNSSDErrorDomain";
NSInteger DNSERROR_TXTRECORD_ENTRY_TOO_LONG = 1000;

BOOL DNSSD_validTxtRecord(NSDictionary *txtRecord) {
    NSError* error;
    DNSSD_NSStringFromTxtRecord(txtRecord, &error);
    return error == nil;
}

NSString* DNSSD_NSStringFromTxtRecord(NSDictionary *txtRecord, NSError** error) {
    if(error)
        *error = nil;

    if(txtRecord.allKeys.count > 0) {
        NSMutableData *result = NSMutableData.new;
        for(NSString* key in txtRecord.allKeys) {
            NSString* value = [txtRecord[key] description];

            NSUInteger keyLen = [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSUInteger valueLen = [value lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSUInteger entryLen = 1 + keyLen + valueLen;

            if(entryLen > 255) {
                if(error)
                    *error = [NSError errorWithDomain:DNSSDErrorDomain code:DNSERROR_TXTRECORD_ENTRY_TOO_LONG userInfo:nil];
                return nil;
            }

            unsigned char entryLenByte = (unsigned char)entryLen;
            unsigned char equalsChar = '=';

            [result appendBytes:&entryLenByte length:1];
            [result appendBytes:key.UTF8String length:keyLen];
            [result appendBytes:&equalsChar length:1];
            [result appendBytes:value.UTF8String length:valueLen];
        }
        return [NSString.alloc initWithData:result encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }

}
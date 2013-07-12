#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString * const DNSSDErrorDomain;

BOOL DNSSD_validTxtRecord(NSDictionary * txtRecord);
NSString* DNSSD_NSStringFromTxtRecord(NSDictionary *txtRecord, NSError** error);
NSDictionary *DNSSD_NSDictionaryFromTxtRecord(NSString* txtRecord);
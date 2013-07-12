#import <Foundation/Foundation.h>

#define DNSSD_USE_P2P 1


#if DNSSD_USE_P2P
    #define DNSSD_SERVICE_FLAGS kDNSServiceFlagsIncludeP2P
#else
    #define DNSSD_SERVICE_FLAGS 0
#endif

FOUNDATION_EXPORT NSString * const DNSSDErrorDomain;

BOOL DNSSD_validTxtRecord(NSDictionary * txtRecord);
NSString* DNSSD_NSStringFromTxtRecord(NSDictionary *txtRecord, NSError** error);
NSDictionary *DNSSD_NSDictionaryFromTxtRecord(NSString* txtRecord);
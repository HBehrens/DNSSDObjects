//
//  iOS_DNSDObjectsTests.m
//  iOS_DNSDObjectsTests
//
//  Created by Heiko Behrens on 11.07.13.
//  Copyright (c) 2013 Heiko Behrens. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DNSSDUtils.h"

@interface DNSSDUtilsTests : SenTestCase

@end

@implementation DNSSDUtilsTests

-(void)testTxtRecord_nil {
    NSDictionary * txtRecord = nil;
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"empty allowed");
}

-(void)testTxtRecord_stringsAndNumbers {
    NSDictionary * txtRecord = @{@"a": @"foo", @"b": self};
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"any object allowed");
}

-(void)testTxtRecord_singleKeyTooLong {
    NSUInteger len = 255-2;
    NSString* longString = [@"" stringByPaddingToLength:len withString:@"c" startingAtIndex:0];
    NSMutableDictionary * txtRecord = @{@"a": longString, @"b": longString}.mutableCopy;
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"each entry can be 255 chars");

    txtRecord[@"k3"] = longString;
    NSLog(@"%@", NSNetServicesErrorDomain);
    STAssertFalse(DNSSD_validTxtRecord(txtRecord), @"third entry exceeds length len(key+'='+value) > 255");
}

-(void)testTxtRecord_singleKey {
    NSDictionary * txtRecord = @{@"foo": @"bar"};
    NSString *actual = DNSSD_NSStringFromTxtRecord(txtRecord, nil);

    STAssertEqualObjects(@"\7foo=bar", actual, @"");
}

-(void)testTxtRecord_twoKeys {
    NSDictionary * txtRecord = @{@"foo": @"bar", @"baz": @"23"};
    NSString *actual = DNSSD_NSStringFromTxtRecord(txtRecord, nil);

    STAssertEqualObjects(@"\7foo=bar\6baz=23", actual, @"");
}


@end

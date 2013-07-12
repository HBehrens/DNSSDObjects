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

-(void)testValidTxtRecord_nil {
    NSDictionary * txtRecord = nil;
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"empty allowed");
}

-(void)testValidTxtRecord_stringsAndNumbers {
    NSDictionary * txtRecord = @{@"a": @"foo", @"b": self};
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"any object allowed");
}

-(void)testValidTxtRecord_singleKeyTooLong {
    NSUInteger len = 255-2;
    NSString* longString = [@"" stringByPaddingToLength:len withString:@"c" startingAtIndex:0];
    NSMutableDictionary * txtRecord = @{@"a": longString, @"b": longString}.mutableCopy;
    STAssertTrue(DNSSD_validTxtRecord(txtRecord), @"each entry can be 255 chars");

    txtRecord[@"k3"] = longString;
    STAssertFalse(DNSSD_validTxtRecord(txtRecord), @"third entry exceeds length len(key+'='+value) > 255");
}

-(void)testNSStringFromTxtRecord_singleEntry {
    NSDictionary * txtRecord = @{@"foo": @"bar"};
    NSString *actual = DNSSD_NSStringFromTxtRecord(txtRecord, nil);

    STAssertEqualObjects(@"\7foo=bar", actual, @"");
}

-(void)testNSStringFromTxtRecord_twoEntries {
    NSDictionary * txtRecord = @{@"foo": @"bar", @"baz": @"23"};
    NSString *actual = DNSSD_NSStringFromTxtRecord(txtRecord, nil);

    STAssertEqualObjects(@"\7foo=bar\6baz=23", actual, @"");
}

-(void)testNSDictionaryFromTxtRecord_nil {
    STAssertEqualObjects(nil, DNSSD_NSDictionaryFromTxtRecord(nil), @"nil");
}

-(void)testNSDictionaryFromTxtRecord_emptyString {
    NSString *txtRecord = [NSString.alloc initWithBytes:NULL length:0 encoding:NSUTF8StringEncoding];
    STAssertNotNil(txtRecord, @"string");
    STAssertEqualObjects(@{}, DNSSD_NSDictionaryFromTxtRecord(txtRecord), @"nil");
}

-(void)testNSDictionaryFromTxtRecord_singleEntry {
    NSString *txtRecord = @"\7foo=bar";
    NSDictionary *expected = @{@"foo": @"bar"};
    NSDictionary *actual = DNSSD_NSDictionaryFromTxtRecord(txtRecord);
    STAssertEqualObjects(expected, actual, @"...");
}

-(void)testNSDictionaryFromTxtRecord_twoEntries {
    NSString *txtRecord = @"\7foo=bar\6baz=23";
    NSDictionary *expected = @{@"foo": @"bar", @"baz": @"23"};
    NSDictionary *actual = DNSSD_NSDictionaryFromTxtRecord(txtRecord);
    STAssertEqualObjects(expected, actual, @"...");
}

-(void)testNSDictionaryFromTxtRecord_boolean {
    NSString *txtRecord = @"\3foo";
    NSDictionary *expected = @{@"foo": @YES};
    NSDictionary *actual = DNSSD_NSDictionaryFromTxtRecord(txtRecord);
    STAssertEqualObjects(expected, actual, @"...");
}

-(void)testNSDictionaryFromTxtRecord_stripsValueIfContainsEquals {
    NSString *txtRecord = @"\7foo=b=a";
    NSDictionary *expected = @{@"foo": @"b"};
    NSDictionary *actual = DNSSD_NSDictionaryFromTxtRecord(txtRecord);
    STAssertEqualObjects(expected, actual, @"...");
}


@end

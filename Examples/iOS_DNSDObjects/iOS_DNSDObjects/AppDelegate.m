//
//  AppDelegate.m
//  iOS_DNSDObjects
//
//  Created by Heiko Behrens on 11.07.13.
//  Copyright (c) 2013 Heiko Behrens. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "DNSSDRegistration.h"
#import "DNSSDBrowser.h"
#import "DNSSDService.h"

@interface AppDelegate()<DNSSDRegistrationDelegate, DNSSDBrowserDelegate, DNSSDServiceDelegate>

@end

@implementation AppDelegate{
    DNSSDRegistration* _reg;
    DNSSDBrowser* _browser;
    NSMutableSet* _services;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    _services = NSMutableSet.set;
    NSString* txtValue = @"foobar";
    u_char l = strlen(txtValue.UTF8String);
    char* pascalString = malloc(1+l);
    pascalString[0] = l;
    strcpy(&pascalString[1], txtValue.UTF8String);
    
//    //char* txtRecord = "\4test";
//    char* txtRecord = pascalString;
//    uint16_t txtLen = strlen(txtRecord);
//    txtRecord = NULL;
//    txtLen = 0;
    NSDictionary* txtRecords = @{@"someKey": @"someValue"};
    
    _reg = [DNSSDRegistration.alloc initWithDomain:nil type:@"_http._tcp." name:nil port:1292 txtRecord:txtRecords];
    _reg.delegate = self;
    [_reg start];
    
    _browser = [DNSSDBrowser.alloc initWithDomain:nil type:@"_http._tcp."];
    _browser.delegate = self;
    [_browser startBrowse];
    
    return YES;
}

#pragma mark - DNSSDBrowserDelegate

- (void)dnssdBrowser:(DNSSDBrowser *)browser didAddService:(DNSSDService *)service moreComing:(BOOL)moreComing{
    if(![_services containsObject:service]) {
        NSLog(@"discovered %@ and start resolving...", service);
        [_services addObject:service];
        service.delegate = self;
        [service startResolve];
    } else {
        NSLog(@"re-discovered %@", service);
    }
}

- (void)dnssdBrowser:(DNSSDBrowser *)browser didRemoveService:(DNSSDService *)service moreComing:(BOOL)moreComing{
    [_services removeObject:service];
    NSLog(@"remove: %@", service);
}

#pragma mark - DNSSDServiceDelegate

- (void)dnssdServiceDidResolveAddress:(DNSSDService *)service{
    NSLog(@"did resolve %@ as %@:%d", service, service.resolvedHost, service.resolvedPort);
}

@end

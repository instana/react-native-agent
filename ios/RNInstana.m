/*
 * (c) Copyright IBM Corp. 2021
 * (c) Copyright Instana Inc. and contributors 2021
 */

#import "RNInstana.h"
@import InstanaAgent;

// Error
static NSString *const kErrorDomain = @"com.instana.instana-agent-react-native";
static NSInteger const kErrorDomainCodeWrongRegex = -1;

// Setup OptionKeys
static NSString *const kCollectionEnabled = @"collectionEnabled";

// Custom Event OptionKeys
static NSString *const kCustomEventStartTimeKey = @"startTime";
static NSString *const kCustomEventDurationKey = @"duration";
static NSString *const kCustomEventViewNameKey = @"viewName";
static NSString *const kCustomEventMetaNameKey = @"meta";
static NSString *const kCustomEventBackendTracingIDNameKey = @"backendTracingId";

@implementation RNInstana

RCT_EXPORT_MODULE(Instana)

RCT_EXPORT_METHOD(setup:(nonnull NSString *)key reportingUrl:(nonnull NSString *)reportingUrl options:(NSDictionary *)options)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL enabled = YES;
        if ([[options allKeys] containsObject: kCollectionEnabled]) {
            enabled = [options[kCollectionEnabled] boolValue];
        }
        HTTPCaptureConfig config = HTTPCaptureConfigAutomatic;
        [Instana setupWithKey:key reportingURL:[NSURL URLWithString:reportingUrl] httpCaptureConfig: config collectionEnabled: enabled];
    });
}

RCT_EXPORT_METHOD(setView:(nonnull NSString *)viewName)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setViewWithName: viewName];
    });
}

RCT_EXPORT_METHOD(setUserID:(nonnull NSString *)userID)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setUserWithId:userID];
    });
}

RCT_EXPORT_METHOD(setUserName:(nonnull NSString *)userName)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setUserWithName:userName];
    });
}

RCT_EXPORT_METHOD(setUserEmail:(nonnull NSString *)userEmail)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setUserWithEmail:userEmail];
    });
}

RCT_EXPORT_METHOD(setMeta:(nonnull NSString *)key value:(nonnull NSString*)value)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setMetaWithValue:value key:key];
    });
}

RCT_EXPORT_METHOD(reportEvent:(nonnull NSString *)name options:(NSDictionary *)options)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // We use NSString for the startTime and duration because ObjC does not allow us to send optional NSInteger as parameter
        long long startTime = [[options objectForKey: kCustomEventStartTimeKey] longLongValue];
        long long duration = [[options objectForKey: kCustomEventDurationKey] longLongValue];
        NSDictionary <NSString*, NSString*> *meta = [options objectForKey: kCustomEventMetaNameKey];
        id viewName = [options objectForKey: kCustomEventViewNameKey];
        id backendTracingID = [options objectForKey: kCustomEventBackendTracingIDNameKey];

        if (![viewName isKindOfClass:[NSString class]]) {
            viewName = nil;
        }
        if (![backendTracingID isKindOfClass:[NSString class]]) {
            backendTracingID = nil;
        }
        [Instana reportEventWithName:name
                           timestamp:startTime
                            duration:duration
                    backendTracingID:backendTracingID
                               error:nil
                                meta:meta
                            viewName:viewName];
    });
}

RCT_EXPORT_METHOD(setIgnoreURLsByRegex:(nonnull NSArray <NSString*>*)regexPatterns resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray <NSRegularExpression*> *regexItems = [self convertRegexPatterns: regexPatterns rejecter:reject];
        if ([regexItems count] > 0) {
            [Instana setIgnoreURLsMatching:regexItems];
            resolve(@"Success");
        }
    });
}

RCT_EXPORT_METHOD(getSessionID:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        resolve([Instana sessionID]);
    });
}

RCT_EXPORT_METHOD(getViewName:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        resolve([Instana viewName]);
    });
}

RCT_EXPORT_METHOD(setCollectionEnabled:(BOOL)enabled)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setCollectionEnabled: enabled];
    });
}

RCT_EXPORT_METHOD(getCollectionEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        resolve(@([Instana collectionEnabled]));
    });
}

RCT_EXPORT_METHOD(setRedactHTTPQueryByRegex:(nonnull NSArray <NSString*>*)regexPatterns resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray <NSRegularExpression*> *regexItems = [self convertRegexPatterns: regexPatterns rejecter:reject];
        if ([regexItems count] > 0) {
            [Instana redactHTTPQueryMatching: regexItems];
            resolve(@"Success");
        }
    });
}

- (NSArray <NSRegularExpression*>*)convertRegexPatterns:(nonnull NSArray <NSString*>*)regexPatterns rejecter:(RCTPromiseRejectBlock)reject {
    NSMutableArray <NSRegularExpression*> *regexItems = [@[] mutableCopy];
    NSMutableArray <NSError*> *errors = [@[] mutableCopy];
    for (NSString *pattern in regexPatterns) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: 0 error: &error];
        if (error != nil) {
            [errors addObject:error];
        }
        if (regex != nil) {
            [regexItems addObject:regex];
        }
    }
    if ([errors count] > 0) {
        NSDictionary *userinfo = @{@"UnderlyingErrors":errors};
        NSError *error = [NSError errorWithDomain:kErrorDomain code:kErrorDomainCodeWrongRegex userInfo:userinfo];
        reject([NSString stringWithFormat:@"%ld", kErrorDomainCodeWrongRegex], @"Wrong RegularExpression pattern", error);
        return @[];
    } else {
        return [regexItems copy];
    }
}

@end

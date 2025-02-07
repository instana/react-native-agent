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
static NSString *const kHttpCaptureConfig = @"httpCaptureConfig";
static NSString *const kEnableCrashReporting = @"enableCrashReporting";
static NSString *const kSlowSendInterval = @"slowSendInterval";
static NSString *const kUsiRefreshTimeIntervalInHrs = @"usiRefreshTimeIntervalInHrs";

// Custom Event OptionKeys
static NSString *const kCustomEventStartTimeKey = @"startTime";
static NSString *const kCustomEventDurationKey = @"duration";
static NSString *const kCustomEventViewNameKey = @"viewName";
static NSString *const kCustomEventMetaNameKey = @"meta";
static NSString *const kCustomEventBackendTracingIDNameKey = @"backendTracingId";
static NSString *const kCustomMetric = @"customMetric";
static NSString *const kQueryTrackedDomainList = @"queryTrackedDomainList";

@implementation RNInstana

RCT_EXPORT_MODULE(Instana)

RCT_EXPORT_METHOD(setup:(nonnull NSString *)key reportingUrl:(nonnull NSString *)reportingUrl options:(NSDictionary *)options)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL enabled = YES;
        if ([[options allKeys] containsObject: kCollectionEnabled]) {
            enabled = [options[kCollectionEnabled] boolValue];
        }

        HTTPCaptureConfig httpCapture = HTTPCaptureConfigAutomatic;
        if ([[options allKeys] containsObject: kHttpCaptureConfig]) {
            httpCapture = [options[kHttpCaptureConfig] intValue];
        }

        BOOL crashReporting = NO;
        if ([[options allKeys] containsObject: kEnableCrashReporting]) {
            crashReporting = [options[kEnableCrashReporting] boolValue];
        }

        double slowSendInterval = 0.0;
        if ([[options allKeys] containsObject: kSlowSendInterval]) {
            slowSendInterval = [options[kSlowSendInterval] doubleValue];
        }

        double usiRefreshTimeIntervalInHrs = -1.0;
        if ([[options allKeys] containsObject: kUsiRefreshTimeIntervalInHrs]) {
            usiRefreshTimeIntervalInHrs = [options[kUsiRefreshTimeIntervalInHrs] doubleValue];
        }

        NSArray<NSRegularExpression *> *queryTrackedDomainList = @[];
        if ([[options allKeys] containsObject:kQueryTrackedDomainList]) {
            // Retrieve the array of domain patterns
            NSArray *domainPatterns = options[kQueryTrackedDomainList];
            // Create a mutable array to hold the NSRegularExpression objects
            NSMutableArray *regularExpressions = [NSMutableArray array];
            // Iterate through each domain pattern and create a regular expression
            for (NSString *pattern in domainPatterns) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                if (regex) {
                    [regularExpressions addObject:regex];
                }
            }
            // Assign the regular expressions to the queryTrackedDomainList
            queryTrackedDomainList = [regularExpressions copy];
        }

        InstanaSetupOptions *setupOptions = [[InstanaSetupOptions alloc]
                                    initWithHttpCaptureConfig: httpCapture
                                    collectionEnabled: enabled
                                    enableCrashReporting: crashReporting
                                    suspendReportingOnLowBattery: false
                                    suspendReportingOnCellular: false
                                    slowSendInterval: slowSendInterval
                                    usiRefreshTimeIntervalInHrs: usiRefreshTimeIntervalInHrs
                                    autoCaptureScreenNames: false
                                    debugAllScreenNames: false
                                    queryTrackedDomainList: queryTrackedDomainList
                                    dropBeaconReporting: false];

        HybridAgentOptions* hybridOptions = [[HybridAgentOptions alloc] initWithId: @"r" version: @"2.0.7"];

        #pragma clang diagnostic ignored "-Wunused-result"
        (void)[Instana setupInternalWithKey: key
                               reportingURL: [NSURL URLWithString:reportingUrl]
                                    options: setupOptions
                              hybridOptions: hybridOptions];

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
        double customMetric = NAN;
        if ([[options allKeys] containsObject: kCustomMetric]) {
            customMetric = [[options objectForKey: kCustomMetric] doubleValue];
        }

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
                            viewName:viewName
                        customMetric:customMetric];
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

RCT_EXPORT_METHOD(setCaptureHeadersByRegex:(nonnull NSArray <NSString*>*)regexPatterns resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray <NSRegularExpression*> *regexItems = [self convertRegexPatterns: regexPatterns rejecter:reject];
        if ([regexItems count] > 0) {
            [Instana setCaptureHeadersMatching: regexItems];
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

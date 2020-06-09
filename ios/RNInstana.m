#import "RNInstana.h"
@import InstanaAgent;

// User
static NSString *currentUserId = @"";
static NSString *currentUserEmail = @"";
static NSString *currentUserName = @"";

// Error
static NSString *const kErrorDomain = @"com.instana.instana-agent-react-native";
static NSInteger const kErrorDomainCodeWrongRegex = -1;

// Custom Event OptionKeys
static NSString *const kCustomEventStartTimeKey = @"startTime";
static NSString *const kCustomEventDurationKey = @"duration";
static NSString *const kCustomEventViewNameKey = @"viewName";
static NSString *const kCustomEventMetaNameKey = @"meta";
static NSString *const kCustomEventBackendTracingIDNameKey = @"backendTracingId";

@implementation RNInstana

RCT_EXPORT_MODULE(Instana)

RCT_EXPORT_METHOD(setup:(nonnull NSString *)key reportingUrl:(nonnull NSString *)reportingUrl)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Instana setupWithKey:key reportingURL:[NSURL URLWithString:reportingUrl]];
    });
}

RCT_EXPORT_METHOD(setView:(nonnull NSString *)viewName)
{
    [Instana setViewWithName: viewName];
}

RCT_EXPORT_METHOD(setUserID:(nonnull NSString *)userID)
{
    currentUserId = userID;
    [self updateUser];
}

RCT_EXPORT_METHOD(setUserName:(nonnull NSString *)userName)
{
    currentUserName = userName;
    [self updateUser];
}

RCT_EXPORT_METHOD(setUserEmail:(nonnull NSString *)userEmail)
{
    currentUserEmail = userEmail;
    [self updateUser];
}

RCT_EXPORT_METHOD(setMeta:(nonnull NSString *)key value:(nonnull NSString*)value)
{
    [Instana setMetaWithValue:value key:key];
}

RCT_EXPORT_METHOD(reportEvent:(nonnull NSString *)name options:(NSDictionary *)options)
{
    // We use NSString for the startTime and duration because ObjC does not allow us to send optional NSInteger as parameter
    NSString *startTime = [[options objectForKey: kCustomEventStartTimeKey] stringValue];
    NSString *duration = [[options objectForKey: kCustomEventDurationKey] stringValue];
    NSString *viewName = [options objectForKey: kCustomEventViewNameKey];
    NSDictionary <NSString*, NSString*> *meta = [options objectForKey: kCustomEventMetaNameKey];
    NSString *backendTracingID = [options objectForKey: kCustomEventBackendTracingIDNameKey];
    [Instana reportEventWithName:name timestamp:startTime duration:duration backendTracingID:backendTracingID error:nil meta:meta viewName:viewName];
}

RCT_EXPORT_METHOD(setIgnoreURLsByRegex:(nonnull NSArray <NSString*>*)regexArray resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSMutableArray <NSRegularExpression*> *regexItems = [@[] mutableCopy];
    NSMutableArray <NSError*> *errors = [@[] mutableCopy];
    for (NSString *pattern in regexArray) {
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
    } else {
        [Instana setIgnoreURLsMatching:regexItems];
        resolve(@"Success");
    }
}

RCT_EXPORT_METHOD(getSessionID:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([Instana sessionID]);
}

RCT_EXPORT_METHOD(getViewName:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([Instana viewName]);
}

- (void)updateUser {
     [Instana setUserWithId:currentUserId email:currentUserEmail name:currentUserName];
}

@end

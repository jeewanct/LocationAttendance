// Generated by Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import RealmSwift;
@import Foundation;
@import ObjectiveC;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class RLMRealm;
@class RLMObjectSchema;
@class RLMSchema;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk17AccessTokenObject")
@interface AccessTokenObject : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nonnull organizationId;
@property (nonatomic, copy) NSString * _Nonnull token;
@property (nonatomic, copy) NSString * _Nonnull userId;
@property (nonatomic, copy) NSString * _Nonnull organizationName;
@property (nonatomic) NSInteger expires;
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable orgFeatures;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk13AttendanceLog")
@interface AttendanceLog : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable dayofWeek;
@property (nonatomic, copy) NSDate * _Nullable timeStamp;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk10BeaconData")
@interface BeaconData : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable lastSeen;
@property (nonatomic, copy) NSString * _Nullable distance;
@property (nonatomic, copy) NSString * _Nullable rssi;
@property (nonatomic, copy) NSString * _Nullable major;
@property (nonatomic, copy) NSString * _Nullable minor;
@property (nonatomic, copy) NSString * _Nullable uuid;
@property (nonatomic, copy) NSString * _Nullable beaconId;
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable beaconNumber;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

@class NSMutableDictionary;
@class NSDictionary;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk18BlueDolphinManager")
@interface BlueDolphinManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) BlueDolphinManager * _Nonnull manager;)
+ (BlueDolphinManager * _Nonnull)manager SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, copy) NSString * _Nonnull emailId;
@property (nonatomic, strong) NSMutableDictionary * _Nonnull seanbeacons;
- (void)initializeWithSecretKey:(NSString * _Nullable)secretKey organizationId:(NSString * _Nullable)organizationId email:(NSString * _Nullable)email firstName:(NSString * _Nullable)firstName lastName:(NSString * _Nullable)lastName metaInfo:(NSDictionary * _Nullable)metaInfo;
- (void)setConfigWithSecretKey:(NSString * _Nonnull)secretKey organizationId:(NSString * _Nonnull)organizationId;
- (void)authorizeUserWithEmail:(NSString * _Nonnull)email firstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nonnull)lastName metaInfo:(NSDictionary * _Nonnull)metaInfo;
- (void)postTransientCheckinWithMetaInfo:(NSDictionary<NSString *, id> * _Nonnull)metaInfo;
- (void)startScanning;
- (void)updateToken;
- (void)stopScanning;
- (void)sendCheckinsWithArray:(NSArray * _Nonnull)array;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk13CheckinHolder")
@interface CheckinHolder : NSObject
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable accuracy;
@property (nonatomic, copy) NSString * _Nullable altitude;
@property (nonatomic, copy) NSString * _Nullable organizationId;
@property (nonatomic, copy) NSString * _Nullable checkinId;
@property (nonatomic, copy) NSString * _Nullable time;
@property (nonatomic, copy) NSString * _Nullable checkinCategory;
@property (nonatomic, copy) NSString * _Nullable checkinType;
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable checkinDetails;
@property (nonatomic, copy) NSString * _Nullable imageUrl;
@property (nonatomic, copy) NSString * _Nullable assignmentId;
@property (nonatomic, copy) NSString * _Nullable imageName;
@property (nonatomic, copy) NSString * _Nullable relativeUrl;
@property (nonatomic, copy) NSString * _Nullable jobNumber;
@property (nonatomic, copy) NSArray * _Nullable beaconProximities;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk12CheckinModel")
@interface CheckinModel : NSObject
+ (NSInteger)getBeaconCheckinCount SWIFT_WARN_UNUSED_RESULT;
+ (NSInteger)getCheckinCount SWIFT_WARN_UNUSED_RESULT;
+ (void)postCheckinWithCheckinId:(NSString * _Nonnull)checkinId;
+ (void)createCheckinWithCheckinData:(CheckinHolder * _Nonnull)checkinData;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSString;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk15KeychainService")
@interface KeychainService : NSObject
- (NSString * _Nullable)loadWithName:(NSString * _Nonnull)name SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSObject (SWIFT_EXTENSION(BluedolphinCloudSdk))
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk8OTPModel")
@interface OTPModel : NSObject
+ (void)getOtpWithMobile:(NSString * _Nonnull)mobile completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk10OauthModel")
@interface OauthModel : NSObject
+ (void)getTokenWithUserObject:(NSDictionary<NSString *, id> * _Nonnull)userObject completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (void)updateToken;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface RealmSwiftObject (SWIFT_EXTENSION(BluedolphinCloudSdk))
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk9RMCBeacon")
@interface RMCBeacon : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable lastSeen;
@property (nonatomic, copy) NSString * _Nullable distance;
@property (nonatomic, copy) NSString * _Nullable rssi;
@property (nonatomic, copy) NSString * _Nullable major;
@property (nonatomic, copy) NSString * _Nullable minor;
@property (nonatomic, copy) NSString * _Nullable uuid;
@property (nonatomic, copy) NSString * _Nullable beaconId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk11RMCLocation")
@interface RMCLocation : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable altitude;
@property (nonatomic, copy) NSString * _Nullable accuracy;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIDevice (SWIFT_EXTENSION(BluedolphinCloudSdk))
@property (nonatomic, readonly, copy) NSString * _Nonnull modelName;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk13UserDataModel")
@interface UserDataModel : NSObject
+ (void)userSignUpWithParam:(NSDictionary<NSString *, id> * _Nonnull)param completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (void)createUserDataWithUserObject:(NSDictionary<NSString *, NSString *> * _Nonnull)userObject;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk14VicinityBeacon")
@interface VicinityBeacon : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable addedOn;
@property (nonatomic, copy) NSString * _Nullable updatedOn;
@property (nonatomic, copy) NSString * _Nullable uuid;
@property (nonatomic, copy) NSString * _Nullable major;
@property (nonatomic, copy) NSString * _Nullable minor;
@property (nonatomic, copy) NSString * _Nullable beaconId;
@property (nonatomic, copy) NSString * _Nullable address;
@property (nonatomic, copy) NSString * _Nullable organizationId;
@property (nonatomic, copy) NSString * _Nullable placeId;
@property (nonatomic, strong) RMCLocation * _Nullable location;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop

// Generated by Apple Swift version 4.1.2 effective-3.3.2 (swiftlang-902.0.54 clang-902.0.39.2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
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

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
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
# if __has_attribute(objc_subclassing_restricted)
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
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
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
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import RealmSwift;
@import ObjectiveC;
@import Foundation;
@import CoreLocation;
@import Photos;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="BluedolphinCloudSdk",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class RLMRealm;
@class RLMObjectSchema;
@class RLMSchema;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk17AccessTokenObject")
@interface AccessTokenObject : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable organizationId;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable organizationName;
@property (nonatomic) NSInteger expires;
@property (nonatomic, copy) NSString * _Nullable userName;
@property (nonatomic, copy) NSString * _Nullable orgFeatures;
@property (nonatomic, copy) NSString * _Nullable privelege;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk16AssignmentHolder")
@interface AssignmentHolder : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk15AssignmentModel")
@interface AssignmentModel : NSObject
+ (void)getAssignmentsWithAssignmentId:(NSString * _Nonnull)assignmentId completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (void)getAssignmentsWithStatus:(NSString * _Nonnull)status completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (void)updateAssignments;
+ (void)postdbAssignments;
+ (void)postAssignmentsWithAssignment:(NSObject * _Nonnull)assignment;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSDictionary;

@interface AssignmentModel (SWIFT_EXTENSION(BluedolphinCloudSdk))
+ (void)createAssignmentWithAssignmentData:(AssignmentHolder * _Nonnull)assignmentData;
+ (void)saveAssignmentWithAssignmentData:(NSDictionary * _Nonnull)assignmentData;
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

@class BluedolphinLocationManager;
@class NSMutableDictionary;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk18BlueDolphinManager")
@interface BlueDolphinManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) BlueDolphinManager * _Nonnull manager;)
+ (BlueDolphinManager * _Nonnull)manager SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, copy) NSString * _Nonnull emailId;
@property (nonatomic, strong) BluedolphinLocationManager * _Null_unspecified bluedolphinLocationManager;
@property (nonatomic, strong) NSMutableDictionary * _Nonnull seanbeacons;
- (void)initializeWithSecretKey:(NSString * _Nullable)secretKey organizationId:(NSString * _Nullable)organizationId email:(NSString * _Nullable)email firstName:(NSString * _Nullable)firstName lastName:(NSString * _Nullable)lastName metaInfo:(NSDictionary * _Nullable)metaInfo;
- (void)setConfigWithSecretKey:(NSString * _Nonnull)secretKey organizationId:(NSString * _Nonnull)organizationId;
- (void)authorizeUserWithEmail:(NSString * _Nonnull)email firstName:(NSString * _Nonnull)firstName lastName:(NSString * _Nonnull)lastName metaInfo:(NSDictionary * _Nonnull)metaInfo completion:(void (^ _Nonnull)(BOOL))completion;
- (void)postTransientCheckinWithMetaInfo:(NSDictionary<NSString *, id> * _Nonnull)metaInfo;
- (void)getNearByBeaconsWithCompletion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
- (void)startScanningWithCompletion:(void (^ _Nonnull)(BOOL))completion;
- (void)stopScanning;
- (void)updateToken;
- (void)stopLocationMonitoring;
- (void)startLocationMonitoring;
- (void)sendCheckinsWithArray:(NSArray * _Nonnull)array;
- (void)gpsAuthorizationStatusWithGpsStatus:(void (^ _Nonnull)(CLAuthorizationStatus))gpsStatus;
- (void)bluetoothEnabledWithCompletion:(void (^ _Nonnull)(BOOL))completion;
- (void)toSendGPSStateCheckinsWithCurrentStatus:(BOOL)currentStatus;
- (void)toSendBluetoothStateCheckinsWithCurrentStatus:(BOOL)currentStatus;
- (NSInteger)getBeaconDataCount SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class CLLocationManager;
@class CLLocation;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk26BluedolphinLocationManager")
@interface BluedolphinLocationManager : NSObject <CLLocationManagerDelegate>
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) BluedolphinLocationManager * _Nonnull sharedInstance;)
+ (BluedolphinLocationManager * _Nonnull)sharedInstance SWIFT_WARN_UNUSED_RESULT;
+ (void)setSharedInstance:(BluedolphinLocationManager * _Nonnull)value;
@property (nonatomic, readonly) CLLocationAccuracy acceptableLocationAccuracy;
@property (nonatomic, readonly) NSTimeInterval checkLocationInterval;
@property (nonatomic, readonly) BOOL isRunning;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)requestAlwaysAuthorization;
- (void)startUpdatingLocationWithInterval:(NSTimeInterval)interval acceptableLocationAccuracy:(CLLocationAccuracy)acceptableLocationAccuracy;
- (void)stopUpdatingLocation;
- (void)startLocationManager;
- (void)stopLocationManager;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nonnull)error;
- (void)locationManager:(CLLocationManager * _Nonnull)manager didUpdateLocations:(NSArray<CLLocation *> * _Nonnull)locations;
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


SWIFT_CLASS("_TtC19BluedolphinCloudSdk21LocationAttendanceLog")
@interface LocationAttendanceLog : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable dayofWeek;
@property (nonatomic, copy) NSDate * _Nullable timeStamp;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk12LocationData")
@interface LocationData : RealmSwiftObject
@property (nonatomic, copy) NSDate * _Nullable lastSeen;
@property (nonatomic, copy) NSString * _Nullable accuracy;
@property (nonatomic, copy) NSString * _Nullable altitude;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable organizationId;
@property (nonatomic, copy) NSString * _Nullable checkinId;
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable details;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk18MyTeamDetailsModel")
@interface MyTeamDetailsModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk11MyTeamModel")
@interface MyTeamModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
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




@interface PHAssetCollection (SWIFT_EXTENSION(BluedolphinCloudSdk))
@property (nonatomic, readonly) NSInteger photosCount;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk12PlaceDetails")
@interface PlaceDetails : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable placeId;
@property (nonatomic, copy) NSString * _Nullable editedBy;
@property (nonatomic, copy) NSString * _Nullable addedBy;
@property (nonatomic, copy) NSString * _Nullable placeType;
@property (nonatomic, copy) NSString * _Nullable address;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk11RMCAssignee")
@interface RMCAssignee : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable organizationId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

@class RMCLocation;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk19RMCAssignmentObject")
@interface RMCAssignmentObject : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable assignmentId;
@property (nonatomic, copy) NSDate * _Nullable addedOn;
@property (nonatomic, copy) NSDate * _Nullable time;
@property (nonatomic, copy) NSDate * _Nullable updatedOn;
@property (nonatomic, copy) NSString * _Nullable assignmentDetails;
@property (nonatomic, copy) NSString * _Nullable assignmentStatusLog;
@property (nonatomic, copy) NSDate * _Nullable assignmentDeadline;
@property (nonatomic, copy) NSDate * _Nullable assignmentStartTime;
@property (nonatomic, copy) NSString * _Nullable assignmentAddress;
@property (nonatomic, strong) RMCAssignee * _Nullable assignerData;
@property (nonatomic, strong) RMCLocation * _Nullable location;
@property (nonatomic, copy) NSString * _Nullable status;
@property (nonatomic, copy) NSString * _Nullable jobNumber;
@property (nonatomic, copy) NSString * _Nullable bookmarked;
@property (nonatomic, copy) NSDate * _Nullable lastUpdated;
@property (nonatomic, copy) NSString * _Nullable assignmentType;
@property (nonatomic, copy) NSDate * _Nullable downloadedOn;
@property (nonatomic, copy) NSDate * _Nullable submittedOn;
@property (nonatomic, copy) NSString * _Nullable firstTypeAssignment;
@property (nonatomic, copy) NSString * _Nullable placeId;
@property (nonatomic, copy) NSString * _Nullable localStatus;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
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


SWIFT_CLASS("_TtC19BluedolphinCloudSdk10RMCDObject")
@interface RMCDObject : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable dObjectId;
@property (nonatomic, copy) NSString * _Nullable dObjectDetails;
@property (nonatomic) BOOL isUploaded;
+ (NSString * _Nonnull)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk12RMCDObjectId")
@interface RMCDObjectId : RealmSwiftObject
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk17RMCDObjectManager")
@interface RMCDObjectManager : NSObject
+ (void)getDObjectsDetailsWithOrderId:(NSString * _Nonnull)orderId philipsObjectID:(NSString * _Nonnull)philipsObjectID completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (RMCDObject * _Nullable)getDObjectFromDBWithDobjectId:(NSString * _Nonnull)dobjectId SWIFT_WARN_UNUSED_RESULT;
+ (void)saveDobjectInDBWithDObjectDetails:(NSDictionary * _Nonnull)dObjectDetails dobjectId:(NSString * _Nonnull)dobjectId;
+ (void)updateDOBjectWithObjectId:(NSString * _Nonnull)objectId;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk11RMCLocation")
@interface RMCLocation : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable altitude;
@property (nonatomic, copy) NSString * _Nullable accuracy;
@property (nonatomic, copy) NSString * _Nullable associationId;
@property (nonatomic, copy) NSString * _Nullable type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk9RMCPhotos")
@interface RMCPhotos : RealmSwiftObject
+ (NSString * _Nonnull)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

@class RMCPlaceLocation;

SWIFT_CLASS("_TtC19BluedolphinCloudSdk8RMCPlace")
@interface RMCPlace : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable placeId;
@property (nonatomic, copy) NSDate * _Nullable addedOn;
@property (nonatomic, copy) NSDate * _Nullable updatedOn;
@property (nonatomic, copy) NSString * _Nullable placeAddress;
@property (nonatomic, strong) RMCPlaceLocation * _Nullable location;
@property (nonatomic, copy) NSString * _Nullable geoTagName;
@property (nonatomic, copy) NSString * _Nullable associationIds;
@property (nonatomic, copy) NSString * _Nullable localStatus;
@property (nonatomic, copy) NSString * _Nullable status;
@property (nonatomic, strong) PlaceDetails * _Nullable placeDetails;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk16RMCPlaceLocation")
@interface RMCPlaceLocation : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable placeId;
@property (nonatomic, copy) NSString * _Nullable latitude;
@property (nonatomic, copy) NSString * _Nullable longitude;
@property (nonatomic, copy) NSString * _Nullable altitude;
@property (nonatomic, copy) NSString * _Nullable accuracy;
@property (nonatomic, copy) NSString * _Nullable associationId;
@property (nonatomic, copy) NSString * _Nullable type;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk16RMCPlacesManager")
@interface RMCPlacesManager : NSObject
+ (void)getPlaces;
+ (RMCDObject * _Nullable)getDObjectFromDBWithDobjectId:(NSString * _Nonnull)dobjectId SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk7RMCUser")
@interface RMCUser : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable rmcUserShift;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
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
+ (void)updateUserWithParam:(NSDictionary<NSString *, id> * _Nonnull)param completion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk15UserDeviceModel")
@interface UserDeviceModel : NSObject
+ (void)getDeviceStatusWithCompletion:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nonnull))completion;
+ (void)getDObjectsShiftWithCompletion:(void (^ _Nonnull)(NSString * _Nonnull))completion;
+ (void)processShiftDataWithDobject:(NSDictionary * _Nonnull)dobject;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC19BluedolphinCloudSdk5Users")
@interface Users : RealmSwiftObject
@property (nonatomic, copy) NSString * _Nullable dObjId;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable firstName;
@property (nonatomic, copy) NSString * _Nullable lastName;
@property (nonatomic, copy) NSString * _Nullable organisationId;
+ (NSString * _Nullable)primaryKey SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRealm:(RLMRealm * _Nonnull)realm schema:(RLMObjectSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithValue:(id _Nonnull)value schema:(RLMSchema * _Nonnull)schema OBJC_DESIGNATED_INITIALIZER;
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

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop

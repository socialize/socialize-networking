// JRSwizzle.m semver:1.0
//   Copyright (c) 2007-2011 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/MIT
//   https://github.com/rentzsch/jrswizzle

#import "NSObject+JRSwizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)	\
	if (ERROR_VAR) {	\
		NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
		*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
										 code:-1	\
									 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
	}
#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

#define GetClass(obj)	object_getClass(obj)

@implementation NSObject (SZJRSwizzle)

+ (BOOL)sz_jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_ {
	Method origMethod = class_getInstanceMethod(self, origSel_);
	if (!origMethod) {
		SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self class]);
		return NO;
	}
	
	Method altMethod = class_getInstanceMethod(self, altSel_);
	if (!altMethod) {
		SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [self class]);
		return NO;
	}
	
	class_addMethod(self,
					origSel_,
					class_getMethodImplementation(self, origSel_),
					method_getTypeEncoding(origMethod));
	class_addMethod(self,
					altSel_,
					class_getMethodImplementation(self, altSel_),
					method_getTypeEncoding(altMethod));
	
	method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
	return YES;
}

+ (BOOL)sz_jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_ {
	return [GetClass((id)self) sz_jr_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end

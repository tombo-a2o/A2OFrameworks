/*
 * Copyright (c) 2003-2014 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

/*
 * Modification History
 *
 * April 12, 2011		Allan Nathanson <ajn@apple.com>
 * - add SCNetworkReachability "server"
 *
 * March 31, 2004		Allan Nathanson <ajn@apple.com>
 * - use [SC] DNS configuration information
 *
 * January 19, 2003		Allan Nathanson <ajn@apple.com>
 * - add advanced reachability APIs
 */

#include <Availability.h>
#include <TargetConditionals.h>
#include <sys/cdefs.h>
#include <dispatch/dispatch.h>
//#include <dispatch/private.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CoreFoundation/CFRuntime.h>
#include <SystemConfiguration/SystemConfiguration.h>
#include <SystemConfiguration/SCValidation.h>
#include <SystemConfiguration/SCPrivate.h>
//#include <SystemConfiguration/VPNAppLayerPrivate.h>
#include <pthread.h>
#include <libkern/OSAtomic.h>

#if	!TARGET_OS_IPHONE
//#include <IOKit/pwr_mgt/IOPMLibPrivate.h>
#endif	// !TARGET_OS_IPHONE

//#include <notify.h>
//#include <dnsinfo.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <resolv.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/param.h>
#include <net/if.h>
//#include <net/if_dl.h>
//#include <net/if_types.h>
#define	KERNEL_PRIVATE
#include <net/route.h>
#undef	KERNEL_PRIVATE

#include "SCNetworkConnectionInternal.h"
#include "SCNetworkReachabilityInternal.h"

#include <CoreFoundation/CFLogUtilities.h>
#define SCLog(cond,level,...) CFLog(level, __VA_ARGS__)




#define	DEBUG_REACHABILITY_TYPE_NAME			"create w/name"
#define	DEBUG_REACHABILITY_TYPE_NAME_CLONE		"      > clone"
#define	DEBUG_REACHABILITY_TYPE_NAME_OPTIONS		"    + options"

#define	DEBUG_REACHABILITY_TYPE_ADDRESS			"create w/address"
#define	DEBUG_REACHABILITY_TYPE_ADDRESS_CLONE		"         > clone"
#define	DEBUG_REACHABILITY_TYPE_ADDRESS_OPTIONS		"       + options"

#define	DEBUG_REACHABILITY_TYPE_ADDRESSPAIR		"create w/address pair"
#define	DEBUG_REACHABILITY_TYPE_ADDRESSPAIR_CLONE	"              > clone"
#define	DEBUG_REACHABILITY_TYPE_ADDRESSPAIR_OPTIONS	"            + options"

#define	DEBUG_REACHABILITY_TYPE_PTR			"create w/ptr"
#define	DEBUG_REACHABILITY_TYPE_PTR_CLONE		"     > clone"
#define	DEBUG_REACHABILITY_TYPE_PTR_OPTIONS		"   + options"

#define	DNS_FLAGS_FORMAT	"[%s%s%s%s%s]"
#define	DNS_FLAGS_VALUES(t)	t->dnsHaveV4      ? "4" : "",	\
				t->dnsHaveV6      ? "6" : "",	\
				t->dnsHavePTR     ? "P" : "",	\
				t->dnsHaveTimeout ? "T" : "",	\
				t->dnsHaveError   ? "E" : ""


static CFStringRef	__SCNetworkReachabilityCopyDescription	(CFTypeRef cf);
static void		__SCNetworkReachabilityDeallocate	(CFTypeRef cf);

static CFTypeID __kSCNetworkReachabilityTypeID	= _kCFRuntimeNotATypeID;


static const CFRuntimeClass __SCNetworkReachabilityClass = {
	0,					// version
	"SCNetworkReachability",		// className
	NULL,					// init
	NULL,					// copy
	__SCNetworkReachabilityDeallocate,	// dealloc
	NULL,					// equal
	NULL,					// hash
	NULL,					// copyFormattingDesc
	__SCNetworkReachabilityCopyDescription	// copyDebugDesc
};


static pthread_once_t		initialized	= PTHREAD_ONCE_INIT;
static const ReachabilityInfo	NOT_REPORTED	= { 0, 0xFFFFFFFF,	0, { 0 }, FALSE };

#pragma mark -
#pragma mark SCNetworkReachability APIs

static __inline__ CFTypeRef
isA_SCNetworkReachability(CFTypeRef obj)
{
	return (isA_CFType(obj, SCNetworkReachabilityGetTypeID()));
}

CFStringRef
_SCNetworkReachabilityCopyTargetDescription(SCNetworkReachabilityRef target)
{
	CFAllocatorRef			allocator	= CFGetAllocator(target);
	CFMutableStringRef		str;
	SCNetworkReachabilityPrivateRef	targetPrivate	= (SCNetworkReachabilityPrivateRef)target;

	str = CFStringCreateMutable(allocator, 0);
	switch (targetPrivate->type) {
		case reachabilityTypeAddress :
		case reachabilityTypeAddressPair : {
			char		buf[64];

			if (targetPrivate->localAddress != NULL) {
				_SC_sockaddr_to_string(targetPrivate->localAddress, buf, sizeof(buf));
				CFStringAppendFormat(str, NULL, CFSTR("local address = %s"),
						     buf);
			}

			if (targetPrivate->remoteAddress != NULL) {
				_SC_sockaddr_to_string(targetPrivate->remoteAddress, buf, sizeof(buf));
				CFStringAppendFormat(str, NULL, CFSTR("%s%saddress = %s"),
						     targetPrivate->localAddress ? ", " : "",
						     (targetPrivate->type == reachabilityTypeAddressPair) ? "remote " : "",
						     buf);
			}
			break;
		}
		case reachabilityTypeName : {
			CFStringAppendFormat(str, NULL, CFSTR("name = %s"), targetPrivate->name);
			break;
		}
		case reachabilityTypePTR : {
			CFStringAppendFormat(str, NULL, CFSTR("ptr = %s"), targetPrivate->name);
			break;
		}
	}

	return str;
}

static CFStringRef
__SCNetworkReachabilityCopyDescription(CFTypeRef cf)
{
	CFAllocatorRef			allocator	= CFGetAllocator(cf);
	CFMutableStringRef		result;
	CFStringRef			str;
	SCNetworkReachabilityRef	target		= (SCNetworkReachabilityRef)cf;

	result = CFStringCreateMutable(allocator, 0);
	CFStringAppendFormat(result, NULL, CFSTR("<SCNetworkReachability %p [%p]> {"), cf, allocator);

	// add target description
	str = _SCNetworkReachabilityCopyTargetDescription(target);
	CFStringAppend(result, str);
	CFRelease(str);

	CFStringAppendFormat(result, NULL, CFSTR("}"));

	return result;
}


static void
__SCNetworkReachabilityDeallocate(CFTypeRef cf)
{
	SCNetworkReachabilityRef	target		= (SCNetworkReachabilityRef)cf;
	SCNetworkReachabilityPrivateRef	targetPrivate	= (SCNetworkReachabilityPrivateRef)target;

	SCLog((_sc_debug && (_sc_log > 0)), LOG_INFO, CFSTR("%srelease"),
	      targetPrivate->log_prefix);

	/* disconnect from the reachability server */

	if (targetPrivate->serverActive) {
		__SCNetworkReachabilityServer_targetRemove(target);
	}

	/* release resources */

	pthread_mutex_destroy(&targetPrivate->lock);

	if (targetPrivate->name != NULL)
		CFAllocatorDeallocate(NULL, (void *)targetPrivate->name);

	if (targetPrivate->resolvedAddresses != NULL)
		CFRelease(targetPrivate->resolvedAddresses);

	if (targetPrivate->localAddress != NULL) {
		if (targetPrivate->localAddress == targetPrivate->remoteAddress) {
			targetPrivate->remoteAddress = NULL;
		}
		CFAllocatorDeallocate(NULL, (void *)targetPrivate->localAddress);
	}

	if (targetPrivate->remoteAddress != NULL)
		CFAllocatorDeallocate(NULL, (void *)targetPrivate->remoteAddress);

	if (targetPrivate->rlsContext.release != NULL) {
		(*targetPrivate->rlsContext.release)(targetPrivate->rlsContext.info);
	}

	if (targetPrivate->onDemandName != NULL) {
		CFRelease(targetPrivate->onDemandName);
	}

	if (targetPrivate->onDemandRemoteAddress != NULL) {
		CFRelease(targetPrivate->onDemandRemoteAddress);
	}

	if (targetPrivate->onDemandServer != NULL) {
		CFRelease(targetPrivate->onDemandServer);
	}

	if (targetPrivate->onDemandServiceID != NULL) {
		CFRelease(targetPrivate->onDemandServiceID);
	}

	if (targetPrivate->serverDigest != NULL) {
		CFRelease(targetPrivate->serverDigest);
	}

	if (targetPrivate->serverGroup != NULL) {
		dispatch_release(targetPrivate->serverGroup);
	}

	if (targetPrivate->serverQueue != NULL) {
		dispatch_release(targetPrivate->serverQueue);
	}

	if (targetPrivate->serverWatchers != NULL) {
		CFRelease(targetPrivate->serverWatchers);
	}

	if (targetPrivate->nePolicyResult) {
		free(targetPrivate->nePolicyResult);
	}

	return;
}


static void
__SCNetworkReachabilityInitialize(void)
{
	__kSCNetworkReachabilityTypeID = _CFRuntimeRegisterClass(&__SCNetworkReachabilityClass);
}

static SCNetworkReachabilityPrivateRef
__SCNetworkReachabilityCreatePrivate(CFAllocatorRef	allocator)
{
	SCNetworkReachabilityPrivateRef		targetPrivate;
	uint32_t				size;

	/* initialize runtime */
	pthread_once(&initialized, __SCNetworkReachabilityInitialize);

	/* allocate target */
	size          = sizeof(SCNetworkReachabilityPrivate) - sizeof(CFRuntimeBase);
	targetPrivate = (SCNetworkReachabilityPrivateRef)_CFRuntimeCreateInstance(allocator,
										  __kSCNetworkReachabilityTypeID,
										  size,
										  NULL);
	if (targetPrivate == NULL) {
		return NULL;
	}

	bzero((void *)targetPrivate + sizeof(CFRuntimeBase), size);

	targetPrivate->cycle				= 1;
	targetPrivate->last_notify			= NOT_REPORTED;
	targetPrivate->serverBypass			= TRUE; //D_serverBypass;



	targetPrivate->log_prefix[0] = '\0';
	if (_sc_log > 0) {
		snprintf(targetPrivate->log_prefix,
			 sizeof(targetPrivate->log_prefix),
			 "[%p] ",
			 targetPrivate);
	}

	return targetPrivate;
}

SCNetworkReachabilityRef
SCNetworkReachabilityCreateWithAddress(CFAllocatorRef		allocator,
				       const struct sockaddr	*address)
{
	SCNetworkReachabilityPrivateRef	targetPrivate;

	if (address == NULL) {
		_SCErrorSet(kSCStatusInvalidArgument);
		return NULL;
	}

	targetPrivate = __SCNetworkReachabilityCreatePrivate(allocator);
	if (targetPrivate == NULL) {
		return NULL;
	}

	targetPrivate->type = reachabilityTypeAddress;
	targetPrivate->remoteAddress = CFAllocatorAllocate(NULL, /*address->sa_len*/ sizeof(struct sockaddr), 0);
	bcopy(address, targetPrivate->remoteAddress, /*address->sa_len*/ sizeof(struct sockaddr));



	SCLog((_sc_debug && (_sc_log > 0)), LOG_INFO, CFSTR("%s%s %@"),
	      targetPrivate->log_prefix,
	      DEBUG_REACHABILITY_TYPE_ADDRESS,
	      targetPrivate);

	return (SCNetworkReachabilityRef)targetPrivate;
}

SCNetworkReachabilityRef
SCNetworkReachabilityCreateWithAddressPair(CFAllocatorRef		allocator,
					   const struct sockaddr	*localAddress,
					   const struct sockaddr	*remoteAddress)
{
    assert(0);
}


SCNetworkReachabilityRef
SCNetworkReachabilityCreateWithName(CFAllocatorRef	allocator,
				    const char		*nodename)
{
    assert(0);
}

SCNetworkReachabilityRef
SCNetworkReachabilityCreateWithOptions(CFAllocatorRef	allocator,
				       CFDictionaryRef	options)
{
    assert(0);
}

CFTypeID
SCNetworkReachabilityGetTypeID(void)
{
	pthread_once(&initialized, __SCNetworkReachabilityInitialize);	/* initialize runtime */
	return __kSCNetworkReachabilityTypeID;
}


CFArrayRef	/* CFArray[CFData], where each CFData is a (struct sockaddr *) */
SCNetworkReachabilityCopyResolvedAddress(SCNetworkReachabilityRef	target,
					 int				*error_num)
{
    assert(0);
}

Boolean
SCNetworkReachabilityGetFlags(SCNetworkReachabilityRef		target,
			      SCNetworkReachabilityFlags	*flags)
{
	Boolean				ok		= TRUE;

	if (!isA_SCNetworkReachability(target)) {
		_SCErrorSet(kSCStatusInvalidArgument);
		return FALSE;
	}

    *flags = kSCNetworkReachabilityFlagsReachable;
	return ok;
}

Boolean
SCNetworkReachabilitySetCallback(SCNetworkReachabilityRef	target,
				 SCNetworkReachabilityCallBack	callout,
				 SCNetworkReachabilityContext	*context)
{
	return TRUE;
}

Boolean
SCNetworkReachabilityScheduleWithRunLoop(SCNetworkReachabilityRef	target,
					 CFRunLoopRef			runLoop,
					 CFStringRef			runLoopMode)
{
    return TRUE;
}

Boolean
SCNetworkReachabilityUnscheduleFromRunLoop(SCNetworkReachabilityRef	target,
					   CFRunLoopRef			runLoop,
					   CFStringRef			runLoopMode)
{
    return TRUE;
}

Boolean
SCNetworkReachabilitySetDispatchQueue(SCNetworkReachabilityRef	target,
				      dispatch_queue_t		queue)
{
    assert(0);
}

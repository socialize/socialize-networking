//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2005-2008 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMockObject.h>

@interface OCProtocolMockObject : OCMockObject 
{
    BOOL        isClass_;
	Protocol	*mockedProtocol;
}

- (id)initWithProtocol:(Protocol *)aProtocol isClass:(BOOL)isClass;

@end


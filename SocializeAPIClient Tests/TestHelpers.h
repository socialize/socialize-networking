//
//  TestHelpers.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/5/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <OCMock/OCMock.h>

#define REPLACE_PROPERTY(partial, getter, mock, setter, variable) \
    do { \
        [[[partial stub] andReturnFromBlock:^id{ return mock; }] getter]; \
        [[[partial stub] andDo1:^(id value) { \
            variable = value;\
        }] setter:OCMOCK_ANY]; \
    } while (0);



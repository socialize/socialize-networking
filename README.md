SZNetworking
============

The library is similar in intent to
[AFNetworking](https://github.com/AFNetworking/AFNetworking), with a slightly
different architecture, fewer features and a lot less code. It’s meant to be
(nearly) the bare minimum you need to create http requests and manage
NSMutableURLRequests through NSOperation and NSOperationQueue.

It’s not used in any production apps at the moment. Use should be considered
experimental. However, it does have heavy unit test coverage. It is small
enough where bugs should be minimal and you can quickly get a good
understanding of what’s going on if you’d like to help with support. 

``` objective-c
self.operationQueue = [[NSOperationQueue alloc] init];
self.operationQueue.maxConcurrentOperationCount = 5;

NSMutableURLRequest *request = [NSMutableURLRequest HTTPRequestWithMethod:@"GET" scheme:@"https" host:@"api.github.com" path:@"/users/socialize/repos" parameters:nil];
SZURLRequestOperation *operation = [[SZURLRequestOperation alloc] initWithURLRequest:request];
operation.URLCompletionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
    id json = [data objectFromJSONData];
    NSLog(@"%@", json);
};

[self.operationQueue addOperation:operation];
```

Some major differences from AFNetworking:

- Ships with builtin support for signing oauth requests (setting HTTP
Authorization header).  Depends on widely used OAuthCore library for setting
signature.  This is the request-level support for oauth, you are on your own
for UI or auth process.
- Lighter (&lt;1000 SLOC vs &gt;5000 SLOC)
- HTTP request setup (parameters, OAuth) exists on exposed category methods of NSMutableURLRequest
instead of on an included HTTP client class. This is organizational preference and allows
a bit more flexibility when working with url requests.
- Operations autofail if one of their dependencies has already failed.

Planned but missing features:

- Request Pausing. You can pause a queue, but not a request midstream.
- SSL whitelisting
- Progress delegate callbacks.

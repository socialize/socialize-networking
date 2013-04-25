Rationale:

The library is similar in intent to AFNetworking, with a slightly different
architecture, fewer features and a lot less code (~1000 LOC vs ~5000). It’s
meant to be nearly the bare minimum you need to create http requests and manage
NSMutableURLRequests through NSOperation and NSOperationQueue

Some major differences from AFNetworking:

- Ships with builtin support for signing oauth requests (setting HTTP
Authorization header).  Depends on widely used oauthcore library for setting
signature.  This is the request-level support for oauth, you are on your own
for UI or auth process.
- iOS4 compatible in the mainline branch / releases.
- HTTP request setup exists in exposed category methods of NSMutableURLRequest
instead of on an included HTTP client class. This is just organizational preference and allows
more flexibility in what you decide to do with your requests
- Provides support for failing request operations if one of their dependencies has already failed


Planned but missing features:

- Pausing
- SSL whitelisting
- Progress delegate callbacks.

It’s not used in any production apps at the moment. Use should be considered
experimental. However, it does have ~100% unit test coverage. It is small
enough where bugs should be minimal and you can quickly get a good
understanding of what’s going on if you’d like to help with support. 

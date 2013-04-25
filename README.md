Rationale:

The library is similar in intent to AFNetworking, with a slightly different
architecture, fewer features and a lot less code. It’s meant to be nearly the
bare minimum you need to create http requests and manage NSMutableURLRequests
through NSOperation and NSOperationQueue

Some major differences from AFNetworking:

- Smaller SLOC (<1000 lines vs >5000)
- Ships with builtin support for signing oauth requests (setting HTTP
Authorization header).  Depends on widely used oauthcore library for setting
signature.  This is the request-level support for oauth, you are on your own
for UI or auth process.
- HTTP request setup exists in exposed category methods of NSMutableURLRequest
instead of on an included HTTP client class. This is organizational preference and allows
more flexibility in what you can to do with your requests
- Operations autofail if one of their dependencies has already failed

Planned but missing features:

- Request Pausing
- SSL whitelisting
- Progress delegate callbacks.

It’s not used in any production apps at the moment. Use should be considered
experimental. However, it does have heavy unit test coverage. It is small
enough where bugs should be minimal and you can quickly get a good
understanding of what’s going on if you’d like to help with support. 

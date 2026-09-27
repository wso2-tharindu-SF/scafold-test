import service1.service2;

// The injected base address may end in a trailing slash; the generated
// client always joins its own leading-slash resource path onto whatever we
// give it here, so strip a trailing slash rather than string-concatenating.
final string service2BaseUrl = service2Url.endsWith("/")
    ? service2Url.substring(0, service2Url.length() - 1)
    : service2Url;

final service2:Client service2Client = check new (service2BaseUrl);

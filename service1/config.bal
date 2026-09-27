import ballerina/os;

// Base address of the service2 component, injected by the platform. May end
// in a trailing slash.
configurable string service2Url = os:getEnv("SERVICE2_URL");

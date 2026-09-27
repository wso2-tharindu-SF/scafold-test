// This file started as the AUTO-GENERATED stub from the Ballerina OpenAPI
// tool (bal openapi --mode service) against
// specs/design/components/service1/openapi.yaml, with the resource body
// filled in and a catch-all 404 handler added.

import ballerina/http;
import ballerina/log;
import service1.service2;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    resource function get average\-score() returns AverageScore {
        service2:Catalog|error catalogResult = service2Client->/catalog;
        service2:Catalog catalog;
        if catalogResult is error {
            log:printError("failed to fetch catalog from service2", 'error = catalogResult);
            catalog = {count: 0, records: []};
        } else {
            catalog = catalogResult;
        }

        service2:Record[] records = catalog.records;
        int recordCount = records.length();
        log:printInfo("computed average score", recordCount = recordCount);

        if recordCount == 0 {
            return {average: 0};
        }

        int sum = 0;
        foreach service2:Record rec in records {
            sum += rec.score;
        }
        int average = sum / recordCount;
        return {average: average};
    }

    // Catch-all: any path/method this service does not otherwise serve
    // answers a structured 404, per the PRD's unsupported-path behaviour.
    // Not a documented operation in openapi.yaml — a default/catch-all
    // handler outside the generated contract.
    resource function 'default [string... path]() returns http:NotFound {
        NotFoundError notFound = {code: 404, message: "not found"};
        return <http:NotFound>{body: notFound};
    }
}

public type AverageScore record {
    # Sum of every record's score divided by the record count, rounded down
    int average;
};

# Structured body for the catch-all 404 response on any path this service
# does not serve. Not part of openapi.yaml — the PRD keeps it out of the
# documented contract for /average-score and there is no other operation to
# attach it to.
public type NotFoundError record {|
    # HTTP error code
    int code;
    # short human-readable label
    string message;
|};

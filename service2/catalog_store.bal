import ballerina/log;

// The fixed, seeded catalog of ten scored records — held in memory,
// held constant for the life of the process.
final Record[] seededRecords = [
    {id: 1, name: "Alpha", score: 30},
    {id: 2, name: "Bravo", score: 32},
    {id: 3, name: "Charlie", score: 34},
    {id: 4, name: "Delta", score: 36},
    {id: 5, name: "Echo", score: 38},
    {id: 6, name: "Foxtrot", score: 40},
    {id: 7, name: "Golf", score: 33},
    {id: 8, name: "Hotel", score: 35},
    {id: 9, name: "India", score: 31},
    {id: 10, name: "Juliet", score: 41}
];

// Starts in full mode.
string currentMode = "full";

function getCatalogSnapshot() returns Catalog {
    Record[] records = currentMode == "full" ? seededRecords : [];
    int count = records.length();
    log:printInfo("GET /catalog served", recordCount = count, mode = currentMode);
    return {count: count, records: records};
}

function applyCatalogMode(string requestedMode) returns CatalogMode|ErrorBadRequest {
    if requestedMode != "full" && requestedMode != "empty" {
        log:printInfo("PUT /catalog-mode rejected", recordCount = 0, requestedMode = requestedMode);
        Error errorBody = {code: 400, message: "Unrecognized mode", description: string `mode '${requestedMode}' is not recognized; expected 'full' or 'empty'`};
        return <ErrorBadRequest>{body: errorBody};
    }
    currentMode = requestedMode;
    int count = currentMode == "full" ? seededRecords.length() : 0;
    log:printInfo("PUT /catalog-mode applied", recordCount = count, mode = currentMode);
    return {mode: currentMode};
}

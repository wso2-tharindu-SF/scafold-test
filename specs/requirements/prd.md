# scafold-test — PRD

## Problem Statement

Consumers who need a single aggregated figure from a scored catalog today have no
easy way to get it — they must fetch the whole record set themselves and compute
the aggregate on their own side. There is also no reliable way to exercise how a
downstream aggregator behaves when the catalog it depends on is empty, which makes
that scenario hard to test.

## Solution

A two-service system: Service2 holds a scored catalog of records and can be
switched between a full catalog and an empty one through an internal operations
endpoint. Service1 asks Service2 for the current catalog and returns the average
score as a whole number, so a consumer gets the aggregate directly without ever
touching the underlying records.

## Actors

- **API Consumer** — an external client (script, app, or partner system) that
calls Service1's public endpoint to get the current average score. No sign-in
or credentials required.
- **Operator** — an internal actor (an operations user or an automated test
harness) with access to Service2's internal operations endpoint, used to switch
Service2 between full mode and empty mode. This endpoint is never reachable by
the API Consumer or any other external caller.

## User Stories

1. As an API Consumer, I want to request the average score from Service1, so
that I get the aggregated figure without fetching and computing it myself.
2. As an API Consumer, I want a request to a path Service1 does not serve to
return a structured 404 body, so that I can distinguish an unsupported path
from any other outcome.
3. As an Operator, I want to switch Service2 between full mode and empty mode
through its internal operations endpoint, so that I can control which
catalog state Service2 serves next.

## Product Decisions

- Service1's average endpoint is open to any caller — no sign-in or
authentication is required.
- Service2 serves a fixed catalog of scored records, reproduced verbatim as
seed data:
- Service2 starts in full mode, serving exactly the catalog above.
- Service2's internal operations endpoint switches it between full mode (the
catalog above) and empty mode (a catalog with no records). This endpoint is
internal only and is never reachable by the API Consumer.
- Service1 computes the average score of the catalog Service2 currently
serves — the sum of every record's score divided by the number of records —
and returns it as a whole number, discarding any remainder. Against the full
catalog this average is 35.
- The same computation runs for every catalog Service2 can serve; there is no
separate path or separate result for any particular catalog.
- Both Service1 and Service2 log how many records they handled per request.
- A request to a path Service1 does not serve returns a structured 404 body.

## Out of Scope

- What Service1 returns when Service2's catalog is empty — no computed value,
default, or error response for that case is part of this version.
- Any alternative response shape, optional field, or documented empty-catalog
variant on either service's OpenAPI contract — empty mode is a fault
condition for Service1's average endpoint, not a documented alternative
response.
- Any 4xx or 5xx response documented on Service1's average endpoint — that
endpoint's contract documents exactly one response, the successful average.
(The structured 404 above applies only to paths Service1 does not serve, not
to the average endpoint itself.)
- Authentication or credentials of any kind for the API Consumer's access to
Service1.

## Open Questions

None outstanding — all decisions needed to build this version are settled
above.
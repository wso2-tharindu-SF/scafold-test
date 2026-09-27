Feature: Catalog mode control

  @story-3
  Rule: An operator switches Service2 between full mode and empty mode through its internal operations endpoint

    Scenario: Switching to empty mode
      Given Service2 is serving the full catalog of ten seeded records
      When Sam the Operator switches Service2 to empty mode through the internal operations endpoint
      Then Service2 serves a catalog with no records

    Scenario: Switching back to full mode
      Given Service2 is serving an empty catalog
      When Sam the Operator switches Service2 to full mode through the internal operations endpoint
      Then Service2 serves the full catalog of ten records

  @story-3
  @negative
  Rule: The internal operations endpoint is never reachable by the API Consumer

    Scenario: An API Consumer cannot reach the operations endpoint
      Given Alex the API Consumer only has access to Service1's public endpoint
      When Alex attempts to reach Service2's internal operations endpoint directly
      Then the request does not reach Service2 and is refused

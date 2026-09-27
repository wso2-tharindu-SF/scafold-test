Feature: Unsupported paths

  @story-2
  Rule: A request to a path Service1 does not serve returns a structured 404 body

    @negative
    Scenario: Requesting an undefined path
      Given Service1 is running
      When Alex the API Consumer requests "/unknown-path", a path Service1 does not serve
      Then Service1 responds with a structured 404 body

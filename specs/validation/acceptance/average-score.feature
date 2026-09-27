Feature: Average score

  @story-1
  Rule: Service1 returns the average score of Service2's current catalog as a whole number, discarding any remainder

    Scenario: Averaging the full catalog
      Given Service2 is serving the full catalog of ten seeded records
      When Alex the API Consumer requests the average score from Service1
      Then Service1 returns an average score of 35

Feature: Film page details

    As a user, I want more information about a film/series so that I can get more detailed information about it, 
    a synopse, actors and technical team list. 

    Scenario Outline: The user accesses movies details through the Search Page
        Given the user is authenticated
        Then I pause for 5 seconds
        When the user cicks on the first card when searching for <film>
        Then I pause for 5 seconds
        Then I expect the "filmTitle" to be <title>
        Then I expect the "filmTypeAndYear" to be <typeAndYear>
        Then I expect the "filmDuration" to be <duration>

        Examples:
            | film      | title   | typeAndYear     | duration         |
            |"Titanic"  |"Titanic"| "Movie  •  1997"|"Duration: 3h 14m"|
            |"Flutter"  |"Flutter"| "Movie  •  2011"|"Duration: 1h 26m"|






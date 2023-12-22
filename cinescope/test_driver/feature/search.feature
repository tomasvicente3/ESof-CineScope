Feature:  film/series searching

    As a user, I want to search for a film/series to find information about it.

    Scenario: Search for a film/series by title
        Given the user is authenticated
        Then I pause for 5 seconds
        Given the user is on the "search" page
        When the user enters "titanic" in the search bar
        Then it should be displayed a list of film/series cards that roughly match "titanic"

    Scenario: Search for a film/series by title that doesn't exist
        Given the user is authenticated
        Then I pause for 5 seconds
        Given the user is on the "search" page
        When the user enters "asdajsdnjasdjasndjasdoqwo" in the search bar
        Then it should be displayed with a not found message

Feature: user watchlist

    As an user, I want to be able to remove films from my watchlist
    As an user, I want to save films/series to a Watchlist, so that I can easily access them in case I forget them

    Scenario: User saves a film into the watchlist on the search tab and then pops it in watchlists tab
        Given the user is authenticated
        Then I pause for 5 seconds
        Given the user is on the "search" page
        When the user enters "titanic" in the search bar
        Then I pause for 5 seconds
        When the user taps the watchlist button on a entry that resembles "titanic" on the card content
        Then I pause for 5 seconds
        When I go to the "watchlists" page
        Then it should be displayed a list of film/series cards that roughly match "titanic"
        When the user taps the watchlist button on a entry that resembles "titanic" on the card content
        Then I pause for 5 seconds
        Then it should not be displayed a card that roughly matches "titanic"

    Scenario: User saves a film into the watchlist from the film page and then pops it in watchlists tab
        Given the user is authenticated
        Then I pause for 5 seconds
        When the user cicks on the first card when searching for "Titanic"
        Then I pause for 5 seconds
        When I tap the "watchlistButton" button
        Then I pause for 5 seconds
        When I go to the "watchlists" page
        Then it should be displayed a list of film/series cards that roughly match "titanic"
        When the user taps the watchlist button on a entry that resembles "titanic" on the card content
        Then I pause for 5 seconds
        Then it should not be displayed a card that roughly matches "titanic"

        




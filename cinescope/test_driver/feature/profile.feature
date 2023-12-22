Feature: Profile

As an user, I want to be able to customize my CineScope profile. 


    Scenario: User edits the name and bio of the profile
        Given the user is authenticated
        Then I pause for 5 seconds
        Given the user is on the "profile" page
        Then it saves profile state
        Then I tap the "editProfile" button
        Then I pause for 2 seconds
        When I fill the "name" field with "R2D2"
        When I fill the "bio" field with "I'm a robot beep-bop"
        Then I tap the "saveChanges" button
        Then I pause for 5 seconds
        Then I restart the app
        Then I pause for 10 seconds
        When I go to the "profile" page
        Then I expect the "name" to be "R2D2"
        Then I expect the "bio" to be "I'm a robot beep-bop"
        Then it restores profile state

    Scenario: User checks their profile information
        Given the user is authenticated
        Then I pause for 5 seconds
        Given the user is on the "profile" page
        Then I expect the "name" to be "Conta Teste"
        Then I expect the "bio" to be "Bio teste"









@ignore
Feature: Sign Up new user
    
    Background: preconditions
        Given url conduitBaseUrl

    Scenario: Sign Up new user
    Given def userData = { "email": "teste150@test.com", "username": "test150a" }
        Given path 'users'
        And request 
        """
            {
                "user":{
                    "email": #(userData.email),
                    "password": "test.tes123",
                    "username": #(userData.username)
                }
            }
        """
        When method Post
        Then status 201

Feature: Sign Up new user
    
    Background: preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        Given url conduitBaseUrl

    Scenario: Sign Up new user
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        * def randomPassword = dataGenerator.getRandomPassword()
        Given path 'users'
        And request 
        """
            {
                "user":{
                    "email": #(randomEmail),
                    "password": #(randomPassword),
                    "username": #(randomUsername)
                }
            }
        """
        When method Post
        Then status 201
        And match response == 
        """
            {
                "user": {
                    "id": "#number",
                    "email": #(randomEmail),
                    "username": #(randomUsername),
                    "bio": "##string",
                    "image":"#string",
                    "token":"#string"
                }
            }
        """
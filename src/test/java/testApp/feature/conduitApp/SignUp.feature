
Feature: Sign Up new user
    
    Background: preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        * def randomPassword = dataGenerator.getRandomPassword()
        Given url conduitBaseUrl

    Scenario: Sign Up new user
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

    Scenario Outline: Validate Sign Up error messages
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples:
            | email                | password  | username               | errorResponse                                                                      |  
            | #(randomEmail)       | Karate123 | Jess                   | {"errors":{"username":["has already been taken"]}}                                 |
            | jess@test.com        | Karate123 | #(randomUsername)      | {"errors":{"email":["has already been taken"]}}                                    | 
            | #(randomEmail)       |           | #(randomUsername)      | {"errors":{"password":["can't be blank"]}}                                         |
            | #(randomEmail)       | Karate123 |                        | {"errors":{"username":["can't be blank"]}}                                         | 
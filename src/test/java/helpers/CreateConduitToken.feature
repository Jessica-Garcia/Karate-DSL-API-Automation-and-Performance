Feature: Create Conduit Token
    
    Scenario: Create token
        Given url 'https://conduit-api.bondaracademy.com/api'
        Given path 'users/login'
        And request {"user":{"email":"#(conduitUserEmail)","password":"#(conduitUserPassword)"}}
        When method POST
        Then status 200
        * def conduitAuthToken = response.user.token
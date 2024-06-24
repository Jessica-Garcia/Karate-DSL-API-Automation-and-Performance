Feature: tests for the user endpoint

    Background: Define URL
        Given url 'http://localhost:3000'
        
    Scenario: Get all users
        Given path 'usuarios'
        When method Get
        Then status 200
        And match response.usuarios == "#array"
        And match each response.usuarios == "#object"
        And match response.usuarios == "#[69]"
        And match response.quantidade == 69
    
    Scenario: Get a user by id
        Given path 'usuarios'
        And path '09BEUbEl2SnzuKBk'
        When method Get
        Then status 200
        And match response.nome == 'Geneva Kuhic'

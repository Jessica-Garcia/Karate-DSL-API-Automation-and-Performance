Feature: tests for the user endpoint

    Background: Define URL
        Given url 'http://localhost:3000'
        
    Scenario: Get all users
        Given path 'usuarios'
        When method Get
        Then status 200
        And match response.usuarios == "#array" //verifica se a resposta é um array
        And match each response.usuarios == "#object" //verifica se todos os elementos do array são objetos
        And match response.usuarios == "#[46]" //verifica se o array tem 69 elementos
        And match response.quantidade == 46 //verifica se a quantidade de usuários é 69
    
    Scenario: Get a user by id
        Given path 'usuarios'
        And path '09BEUbEl2SnzuKBk'
        When method Get
        Then status 200
        And match response.nome == 'Geneva Kuhic'
    

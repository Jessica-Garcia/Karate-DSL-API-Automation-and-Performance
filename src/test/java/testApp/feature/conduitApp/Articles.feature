Feature: Articles 

    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api'
    
    Scenario: Create a new article
        Given path 'users/login'
        And request {"user":{"email":"jess@test.com","password":"KarateTest-123"}}
        When method POST
        Then status 200
        * def token = response.user.token // save token to a variable

        Given header Authorization = 'Token ' + token // set token to header
        And path 'articles'
        And request {"article":{"title":"testing 2","description":"testing 2","body":"bla bla bla","tagList":["bla"]}}
        When method POST
        Then status 201
        And match response.article.title == 'testing 2'
        
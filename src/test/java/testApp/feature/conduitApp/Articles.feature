Feature: Articles 

    Background: Define URL
        Given url 'https://conduit-api.bondaracademy.com/api'
        Given path 'users/login'
        And request {"user":{"email":"jess@test.com","password":"KarateTest-123"}}
        When method POST
        Then status 200
        * def token = response.user.token // save token to a variable
    
    Scenario: Create a new article

        Given header Authorization = 'Token ' + token // set token to header
        And path 'articles'
        And request {"article":{"title":"testing 3","description":"testing 3","body":"bla bla bla 3","tagList":["bla"]}}
        When method POST
        Then status 201
        And match response.article.title == 'testing 3'
    
    Scenario: Create and Delete article
            
            Given header Authorization = 'Token ' + token // set token to header
            And path 'articles'
            And request {"article":{"title":"testing...","description":"testing...","body":"bla bla bla 5","tagList":["bla"]}}
            When method POST
            Then status 201
            And match response.article.title == 'testing...'
            And def articleId = response.article.slug // save article id to a variable
            
            Given path 'articles', articleId
            When method Get
            Then status 200
            And match response.article.title == 'testing...'

            Given header Authorization = 'Token ' + token
            And path 'articles', articleId
            When method DELETE
            Then status 204

            Given path 'articles', articleId
            When method Get
            Then status 404
            And match response.errors.article[0] == 'not found'
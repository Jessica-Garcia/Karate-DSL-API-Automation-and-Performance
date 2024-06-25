Feature: Articles 

    Background: Define URL
        Given url conduitBaseUrl
    
    Scenario: Create a new article
        And path 'articles'
        And request {"article":{"title":"testing!","description":"testing!","body":"bla bla bla!","tagList":["bla"]}}
        When method POST
        Then status 201
        And match response.article.title == 'testing!'
    
    Scenario: Create and Delete article       
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

            And path 'articles', articleId
            When method DELETE
            Then status 204

            Given path 'articles', articleId
            When method Get
            Then status 404
            And match response.errors.article[0] == 'not found'
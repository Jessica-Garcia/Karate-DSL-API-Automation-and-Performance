Feature: Articles 

    Background: Define URL
        * url conduitBaseUrl
        * def articleRequestBody = read('classpath:testApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

    Scenario: Create a new article
        And path 'articles'
        And request articleRequestBody
        When method POST
        Then status 201
        And match response.article.title == articleRequestBody.article.title
    
    Scenario: Create and Delete article       
            And path 'articles'
            And request articleRequestBody
            
            When method POST
            Then status 201
            And match response.article.title == articleRequestBody.article.title
            And def articleId = response.article.slug // save article id to a variable
            
            Given path 'articles', articleId
            When method Get
            Then status 200
            And match response.article.title == articleRequestBody.article.title

            And path 'articles', articleId
            When method DELETE
            Then status 204

            Given path 'articles', articleId
            When method Get
            Then status 404
            And match response.errors.article[0] == 'not found'
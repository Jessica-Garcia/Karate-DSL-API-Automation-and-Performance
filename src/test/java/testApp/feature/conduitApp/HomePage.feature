Feature: Tests for the home page

    Background: Define URL
        Given url conduitBaseUrl
    
    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200
        And match response.tags contains ['Git', 'bla']
        And match response.tags !contains 'truck'
        And match response.tags == "#array"
        And match each response.tags == "#string"
    

    Scenario: Get 10 articles from the page
        * def isValidDatedTime = read('classpath:helpers/timeValidator.js')

        Given params {"limit": 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount != 9
        And match response == {articles: "#array", articlesCount: "#number"}
        #And match response.articles[*].favoritesCount contains 15 // check all articles and verify if at least one has favoritesCount = 192
        And match each response..favoritesCount  == "#number" // check all articles and verify if all favoritesCount are of type number
        And match response..bio contains null // response.articles.author.bio, verify if any author has bio = null
        And match each response..bio == '##string' // response.articles.author.bio, verify if type of bio is string or null. ## means optional key too.
        #schema validation
        And match each response.articles == 
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#array",
                "createdAt": "#? isValidDatedTime(_)",
                "updatedAt": "#? isValidDatedTime(_)",
                "favorited": "#boolean",
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """

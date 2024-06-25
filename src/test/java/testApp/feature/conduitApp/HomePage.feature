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
        Given params {"limit": 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount != 9
        And match response == {articles: "#array", articlesCount: "#number"}
        And match response.articles[*].favoritesCount contains 15 // check all articles and verify if at least one has favoritesCount = 192
        And match response..bio contains null // response.articles.author.bio, verify if any author has bio = null
        
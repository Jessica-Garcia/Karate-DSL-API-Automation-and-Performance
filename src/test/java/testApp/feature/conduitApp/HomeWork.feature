
Feature: Home Work

    Background: Preconditions
        * url conduitBaseUrl 

    Scenario: Favorite articles
        * def isValidDatedTime = read('classpath:helpers/timeValidator.js')
        # Step 1: Get all articles of the global feed
        Given params {"limit": 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200

        # Step 2: Get the favorites count and slug ID for the first article, save it to variables
        And def initialCount = 0
        And def slugId = response.articles[0].slug

        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles', slugId, 'favorite'
        And request {}
        When method Post
        Then status 200

        # Step 4: Verify response schema
        And match response == 
        """
            {
                "article": {
                    id: "#number",
                    "slug": "#string",
                    "title": "#string",
                    "description": "#string",
                    "body": "#string",
                    "tagList": "#array",
                    "createdAt": "#? isValidDatedTime(_)",
                    "updatedAt": "#? isValidDatedTime(_)",
                    "authorId": "#number",
                    "tagList": "#array",
                    "favorited": "#boolean",
                    "favoritesCount": "#number",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": "#boolean"
                    },
                    "favoritedBy": "#array"
                }
            }
        """

        # Step 5: Verify that favorites article incremented by 1
        And match response.article.favoritesCount == (initialCount + 1)
        
        # Step 6: Get all favorite articles
        Given params {"favorited": "#(conduitUsername)" , "limit": 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        # Step 7: Verify response schema
        And match response == 
        """
            {
                "articles": "#array",
                "articlesCount": "#number"
            }
        """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        And match response.articles[*].slug contains slugId
        
    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        # Step 2: Get the slug ID for the first arice, save it to variable
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array lentgh and save to variable
            #Example
            #* def responseWithComments = [{"article": "first"}, {article: "second"}]
            #* def articlesCount = responseWithComments.length
        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        # Step 11: Get all comments again and verify number of comments decreased by 1
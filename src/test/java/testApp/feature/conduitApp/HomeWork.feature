
Feature: Home Work

    Background: Preconditions
        * url conduitBaseUrl 
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def isValidDatedTime = read('classpath:helpers/timeValidator.js')

    Scenario: Favorite articles
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
        And match response.article.favoritesCount == initialCount + 1
        
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
        # Step 1: Get articles of the global feed
        Given params {"limit": 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200

        # Step 2: Get the slug ID for the first article, save it to variable
        And def slugId = response.articles[0].slug

        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles', slugId, 'comments'
        When method Get
        Then status 200

        # Step 4: Verify response schema
        And match response == 
        """
            {
                "comments": "#array"
            }
        """
        # Step 5: Get the count of the comments array lentgh and save to variable
        And def initialCommentsCount = response.comments.length

        # Step 6: Make a POST request to publish a new comment
        And def commentBody = dataGenerator.getRandomArticleValues().body
        Given path 'articles', slugId, 'comments'
        And request 
        """
            {
                "comment": {
                    "body": "#(commentBody)"
                }
            }
        """
        When method Post
        Then status 200
        
        # Step 7: Verify response schema that should contain posted comment text
        And match response == 
        """
            {
                "comment": {
                    "id": "#number",
                    "createdAt": "#? isValidDatedTime(_)",
                    "updatedAt": "#? isValidDatedTime(_)",
                    "body": "#(commentBody)",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": "#boolean"
                    }
                }
            }
        """
        And def commentId = response.comment.id
        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles', slugId, 'comments'
        When method Get
        Then status 200

        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        And match response.comments == '#[initialCommentsCount + 1]'
        # Step 10: Make a DELETE request to delete comment
        Given path 'articles', slugId, 'comments', commentId
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles', slugId, 'comments'
        When method Get
        Then status 200
        And match response.comments == '#[initialCommentsCount]'
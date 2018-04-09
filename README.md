# Rest
An HTTP networking library for iOS in Swift 4

## Example

### Simple

```swift
//    GET     /posts/1/comments
Rest.prepare(HTTPMethod: .GET, url: Configuration.serverUrl)
    .setURLParams(["posts", "1", "comments"])
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    GET     /posts
Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    GET     /comments?postId=1
Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
    .setParams(["userId" : 1])
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    POST     /posts
Rest.prepare(HTTPMethod: .POST, url: Configuration.post.posts.url)
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    PUT     /posts/1
Rest.prepare(HTTPMethod: .PUT, url: Configuration.serverUrl)
    .setURLParams(["posts", "1"])
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    PATCH     /posts/1
Rest.prepare(HTTPMethod: .PATCH, url: Configuration.serverUrl)
    .setURLParams(["posts", "1"])
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}

//    DELETE     /posts/1
Rest.prepare(HTTPMethod: .DELETE, url: Configuration.serverUrl)
    .setURLParams(["posts", "1"])
    .call { (data, responce, error) in
        if error == nil {
            print(data ?? "No data")
        }else{
            print(error?.localizedDescription ?? "error")
        }
}
    
```

# Contributing to Rest

Rest welcomes contributions to our [open source projects on Github](https://github.com/ERbittuu/Rest).

Issues
------

Feel free to submit issues and enhancement requests.

Contributing
------------

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that I can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

# Thanks 🍺

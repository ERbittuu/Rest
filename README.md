# Rest
An HTTP networking library for iOS in Swift 4

## Features 
    1. Support all basic service type  
    2. Multipart file support 
    3. Request Cancel support 
    4. Inbuilt log support 
    5. Network Activity Indicator support


## Example


```swift
    
     var cs : CancellationSource?
    
    // request from server 
        
    self.cs = WebService.shared.simpleGET{ data in
            // Do something with data
            }
        
    // Handler called when service cancelled manually
        self.cs?.token.register {
            print("I have cancelled request stop unwanted task here")
        }
    }

    // Request cancelled by user 
        cs?.cancel()

    class WebService {
        
        private init() { }
        static var shared : WebService {
            let service = WebService()
            Rest.default.showLogs = true
            return service
        }
        
        func simpleGET(with completion: @escaping ((_ data : Data?) -> ())) -> CancellationSource {
            // Create cancellable token
            let source = CancellationSource()
            //    GET     /posts
            Rest.prepare(HTTPMethod: .GET, url: Configuration.post.posts.url)
                .call(cancelToken: source.token) { (data, responce, error) in
                    // send completion data
                    //completion(data)
            }
            return source
        }       
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

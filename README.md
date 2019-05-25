# Gist Runner

like AWS Lambda, but much lighter, and only for Ruby!

## Get started
write some ruby code in gist.github.com

e.g.
```
https://gist.github.com/jcouyang/edc3d175769e893b39e6c5be12a8526f
                       |
       add an .ru here |
                       v
https://gist.github.com.ru/jcouyang/edc3d175769e893b39e6c5be12a8526f
```

then you will got an API

## Global Variables

### `req`
`req` is instance of `Rack::Request`
so it basically contains everything of a http request

But you probably just need `req` to get some headers

Headers in `Rack::Request` preffixed with `HTTP_` and `-` to `_`

for instance you want to get a Header with name `X-API-KEY`
```
req.get_header('HTTP_X_API_KEY')
```

### `params`
`params` contains `form` and `query`
### `body`
if `Content-Type` is `application/json`, body is the json body


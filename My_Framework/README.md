=== Elements to creating a simple Rack application ===

1. Any file ending in `.ru` (typically called `config.ru`). This is a rackup file that tells the server what to run
2. The application to run that contains a class with a `call(env)` method. This method returns a 3 element array containing:
  a. status code (string)
  b. headers (hash)
  c. response body (responds to `each`)



=== How to start a Rack application ===

1. Run the `rackup` command using `bundle exec`
```
  bundle exec rackup config.ru -p 9595
```

`-p` allows us to specify the port
`9595` is the port number
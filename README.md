This is a dummy tool to activate on http2debug=2 setting in a remote golang process on the fly while it is running.
(Think about greybox testing.)

Example:
Spin up an HTTP/2 server by following this guide:

https://posener.github.io/http2/

Start it, then run:

```
 ./go-http2-verbose.sh $(pidof h2server)
```

Then send an example request:

```
curl --http2-prior-knowledge --http2 https://127.0.0.1:8000/foo -v -k
```

On the stderr of the server application, lines like this will show up:

```
2021/08/13 09:16:36 http2: decoded hpack field header field ":method" = "GET"
2021/08/13 09:16:36 http2: decoded hpack field header field ":path" = "/foo"
2021/08/13 09:16:36 http2: decoded hpack field header field ":scheme" = "https"
2021/08/13 09:16:36 http2: decoded hpack field header field ":authority" = "127.0.0.1:8000"
2021/08/13 09:16:36 http2: decoded hpack field header field "user-agent" = "curl/7.68.0"
2021/08/13 09:16:36 http2: decoded hpack field header field "accept" = "*/*"
```

The other script, `remote-setenv.sh` can be used to set an environment variable in a remote process
on the fly. Calling it with `GODEBUG http2debug=2` would not work, as this envvar is processed early
in a package initializer of `net/http`.



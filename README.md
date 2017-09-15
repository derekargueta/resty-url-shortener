resty-url-shortener
===================


This is an application implemented with OpenResty and Redis to provide url-shortening functionality.


Start the application with
```
docker-compose-up
```

which will start the application on `localhost:8000`.

To shorten a URL, use `localhost:8000/?url={URL_TO_SHORTEN}` which will display a hash.

That URL can then be expanded with `localhost:8000/{HASH}` which will auto-redirect you to the site.

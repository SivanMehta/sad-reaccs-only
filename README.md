# :cry: Reaccs Only:

Analyzing how people react to the [New York Times on Facebook](https://www.facebook.com/nytimes/). Can we predict how people will react given the text of the message?

Facebook Graph API limits you only to 100 posts per API call, so I'm just gonna update the dataset in this repo with by-day results via `npm run pull`. On my Macbook, it takes about 2.2 seconds to run:

```
➜  sad-reaccs-only git:(master) ✗ time npm run pull
npm info it worked if it ends with ok
npm info using npm@5.0.0
npm info using node@v6.10.1
npm info lifecycle sad-reaccs-only@1.0.0~prepull: sad-reaccs-only@1.0.0
npm info lifecycle sad-reaccs-only@1.0.0~pull: sad-reaccs-only@1.0.0

> sad-reaccs-only@1.0.0 pull /Users/admin/Documents/Side Projects/sad-reaccs-only
> ./pull.js > ids/$(date +'%Y-%m-%d').csv

npm info lifecycle sad-reaccs-only@1.0.0~postpull: sad-reaccs-only@1.0.0
npm info ok
npm run pull  1.24s user 0.14s system 62% cpu 2.231 total
```

#!/usr/bin/env node

var FB = require('fb')
const config = require("./config.json")

var accessToken;

FB.api('oauth/access_token', {
    client_id: config.client_id,
    client_secret: config.client_secret,
    grant_type: 'client_credentials'
}, (res) => {
  if(!res || res.error) {
    console.log(!res ? 'error occurred' : res.error);
    return
  }
  FB.setAccessToken(res.access_token)

  FB.api('/nytimes/feed', 'GET', {"fields":"id","limit":"100"}, (feed) => {
    console.log("post_id")
    feed.data.map(item => {
      console.log(item.id)
    })
  })
})

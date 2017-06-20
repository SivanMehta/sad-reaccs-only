#!/usr/bin/env node

var FB = require('fb')
const config = require("./config.json")
const article_id = "5281959998_10151208305644999"

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

  FB.api(article_id + '/reactions', 'GET', {"fields":"type","limit":"1000"}, (response) => {
    reactions = {
      LIKE: 0,
      HAHA: 0,
      SAD: 0,
      LOVE: 0,
      ANGRY: 0,
      WOW: 0,
      PRIDE: 0
    }
    response.data.map(react => {
      reactions[react.type] += 1
    })
    console.log(reactions)
  })
})

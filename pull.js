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

  FB.api('/nytimes/feed', 'GET', { "fields": "created_time,id,message", "limit":"100" }, (feed) => {
    console.log("post_id\ttimestamp\ttext\tLIKE\tHAHA\tSAD\tLOVE\tANGRY\tWOW\tPRIDE")
    feed.data.map(item => {
      FB.api(item.id + '/reactions', 'GET', {"fields":"type","limit":"1000"}, (response) => {
        reactions = { LIKE: 0, HAHA: 0, SAD: 0, LOVE: 0, ANGRY: 0, WOW: 0, PRIDE: 0 }
        response.data.map(react => {
          reactions[react.type] += 1
        })
        console.log(
          item.id + "\t" +
          item.created_time + "\t" +
          escape(item.message) + "\t" +
          reactions.LIKE + "\t" +
          reactions.HAHA + "\t" +
          reactions.SAD + "\t" +
          reactions.LOVE + "\t" +
          reactions.ANGRY + "\t" +
          reactions.WOW + "\t" +
          reactions.PRIDE + "\t"
        )
      })
    })
  })
})

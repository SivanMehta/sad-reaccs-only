#!/usr/bin/env node

var FB = require('fb')

// The configuration file is not included in version control because
// it contains my client_id and client_secret. You can get your own here:
// https://developers.facebook.com/apps/
const config = require("./config.json")
var accessToken

function getReaccs(item) {
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
}

function setToken(response) {
  if(!response || response.error) {
    return console.log(!response ? 'error occurred' : response.error)
  }
  FB.setAccessToken(response.access_token)

  FB.api('/nytimes/feed', 'GET', { "fields": "created_time,id,message", "limit":"1000" }, (feed) => {
    console.log("post_id\ttimestamp\ttext\tLIKE\tHAHA\tSAD\tLOVE\tANGRY\tWOW\tPRIDE")
    feed.data.map(getReaccs)
  })
}

FB.api('oauth/access_token', {
  client_id: config.client_id,
  client_secret: config.client_secret,
  grant_type: 'client_credentials'
}, setToken)

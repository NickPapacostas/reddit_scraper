# Lil Scrapey Script for Cousin Mike!

This script uses [Redd](https://github.com/avinashbot/redd) to get posts from reddit and write them and their comments to a friendly json format for lil cuzzy Mikey. 

## Installing

- [Install ruby!](https://www.ruby-lang.org/en/documentation/installation/)
- Install Bundler: `gem install bundler`
- clone the repo, install dependencies:
  

  `git clone github.com/nickPapacostas/reddit_scraper` 
  

  `cd reddit_scraper` 
  

  `bundle install`

- add the secr3ts to your environment: 

`REDDIT_CLIENT_ID`

`REDDIT_SECRET`

`REDDIT_UNAME`

`REDDIT_PASS`

## running

The script takes 4 optional params: subreddit, listing (hot, new, top), limit (the number of posts to get), and interactive (true|false)

e.g. `ruby lib/scraper.rb ethereum top 80 false`

The "interactive" flag lets you start a ruby prompt with the data available as instance variables (@posts, @output)

!! right now "limit" can only go up to 100 (~.~) !!

### Output

The script writes all this to "out.json"

the general format is 

```
[
  { 
    title: "post title",
    url: "posturl.com",
    ups: 3, 
    downs: 4,
    comments: [
      {
        body: "first comment",
        ups: 3,
        downs: 4, 
        replies: []
    ]
]
```

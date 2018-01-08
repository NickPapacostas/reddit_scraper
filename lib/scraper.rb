require 'json'
require 'redd'
require 'pry'


CLIENT_ID = ENV['REDDIT_CLIENT_ID']  
CLIENT_SECRET = ENV['REDDIT_SECRET'] 
REDDIT_UNAME = ENV['REDDIT_UNAME'] 
REDDIT_PASS = ENV['REDDIT_PASS'] 

raise "Couldn't find reddit client id!" if CLIENT_ID.nil?
raise "Couldn't find reddit client secret!" if CLIENT_SECRET.nil?
raise "Couldn't find reddit username!" if REDDIT_UNAME.nil?
raise "Couldn't find reddit password!" if REDDIT_PASS.nil?

subreddit = ARGV.shift || "ethereum"
listing = (ARGV.shift || :hot).to_sym # top, new, gilded
limit = (ARGV.shift || 50).to_i # top, new, gilded
interactive = (ARGV.shift || false)


session = Redd.it(
  user_agent: 'Redd:RandomBot:v1.0.0 (by /u/Mustermind)',
  client_id:  CLIENT_ID,
  secret:     CLIENT_SECRET,
  username:   REDDIT_UNAME,
  password:   REDDIT_PASS
)

@posts = session
  .subreddit(subreddit)
  .listing(listing, limit: limit)

puts "Got #{@posts.to_a.count} posts from #{subreddit} subreddit"
puts "Making them into pretty json for cousin Mike....."

def parse_comments(comments)
  comments.map do |comment|
    {
      body: comment.body,
      ups: comment.ups,
      downs: comment.downs,
      replies: parse_replies(comment.replies[0...-1])
    }
  end
end

def parse_replies(replies)
  return [] if replies.empty?
  replies.map do |reply|
    {
      body: reply.body,
      ups: reply.ups,
      downs: reply.downs,
      replies: parse_replies(reply.replies[0...-1])
    }
  end
end

@output = @posts.map do |post|
  {
    title: post.title,
    url: post.url,
    ups: post.ups,
    downs: post.downs,
    comments: parse_comments(post.comments[0...-2])
  }
end


File.write('out.json', @output.to_json)

Pry.start if interactive == "true"
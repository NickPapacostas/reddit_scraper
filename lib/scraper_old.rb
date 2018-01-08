require 'json'
require 'typhoeus'
require 'pry'



subreddit = ARGV.shift || "ethereum"

reddit_url = "https://www.reddit.com/r/#{subreddit}/new.json?sort=new&limit=100"

HEADERS = {
  headers: {"User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.81 Safari/537.36"}
}

puts "Getting data for #{reddit_url}"

@body = nil
@results = []

req = Typhoeus::Request.new(reddit_url, HEADERS)
req.on_complete do |response|
  if response.success?
    @body = JSON.parse(response.body)
  else
    puts "reqqy failed biiiiii #{reddit_url}: #{response.code}"
  end
end

req.run


def build_request_for_link(link)
  r = Typhoeus::Request.new(link[:permalink], HEADERS)
  r.on_complete do |response|
    if response.success?
      @results << build_result(link, JSON.parse(response.body))
    else
      puts "couldnt get #{link}: #{response.code}"
    end
  end
end

def build_result(link, response)
  {
    link: link[:permalink],
    ups: link[:ups],
    downs: link[:downs],
    comments: comments_for_response(response)
  }
end

def comments_for_response(response)

end

puts "Found #{@body["data"]["children"].length} links"


link_results = @body["data"]["children"].map do |c| 
  {
    permalink: c["data"]["permalink"], 
    ups: c["data"]["ups"], 
    downs: c["data"]["downs"]
  }
end

link_reqs = link_results.map {|l| build_request_for_link(l)}

@r = Typhoeus.get("https://reddit.com" + link_results[0][:permalink], HEADERS)

Pry.start
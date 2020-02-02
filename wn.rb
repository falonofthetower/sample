require 'nokogiri'
require 'open-uri'
require 'pry'

root = "https://fee.org/shows/audio/words-numbers/"
doc = Nokogiri::HTML(open(root)) # this fetches the site

count = 1 # start at 1
blurbs = [] # an array to hold the blurbs for the episodes
loop do
  # this is the XPATH for the first episode. You can use inspect and copying
  # this string is one of the options when right clicking
  episode = doc.xpath("//*[@id='full-content-container']/main/div/div[3]/ui-view/div[4]/div[2]/div[#{count}]/a[1]")

  # limit to ten for testing
  # Eventually you would get [] back from the above line which means you have
  # done all the episodes
  break if episode.empty? || count > 10 

  # This fetches the path to the next episode we identified
  path = episode.attribute('href').value

  # We open the episode using the link we found
  episode_doc = Nokogiri::HTML(open("#{root}#{path}"))

  # this xpath is to the description of the episode
  blurbs << episode_doc.xpath('//*[@id="player"]/div[2]/div[2]/div[2]/p[1]').text

  #increment to move the next run of the loop to the next episode
  count += 1

  # limit speed so as to not crash the site
  sleep(2)
end

# this will pop open a console in the local scope. You can then do things with
# the result of blurbs
require 'pry'; binding.pry;

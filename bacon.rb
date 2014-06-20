require 'nokogiri'
require 'open-uri'

WIKIPEDIA_ROOT = 'http://en.wikipedia.org/wiki/'

BACON = 'Kevin_Bacon'

def get_links(url)
  doc = Nokogiri::HTML(open("#{WIKIPEDIA_ROOT}#{url}"))

  doc.css('#mw-content-text a').select { |link|
    link.attributes['href'] && !link.attributes['class']
  }.map { |link|
    link.attributes['href'].text
  }.select { |link|
    link.start_with?('/wiki')
  }.map { |link|
    link[6..-1]
  }.reject { |link|
    link.start_with?('Special:') ||
    link.start_with?('Template:') ||
    link.start_with?('Category:') ||
    link.start_with?('Wikipedia:') 
  }
end

queue = [['Philosophy']]
seen  = {}

while path = queue.shift
  node = path.last
  next if seen[node]
  seen[node] = true

  puts "getting links for #{node}"
  links = get_links(node)

  if links.include? BACON
    puts '*' * 20
    puts path, BACON
    puts '*' * 20
    break
  end

  queue += links.map { |link| path + [link] }
end

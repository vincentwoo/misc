require 'nokogiri'
require 'typhoeus'

WIKIPEDIA_ROOT = 'http://en.wikipedia.org/wiki/'
BACON = 'Kevin_Bacon'

def get_links(url)
  begin
    html = Typhoeus.get("#{WIKIPEDIA_ROOT}#{url}").body
    doc = Nokogiri::HTML(html)
  rescue
    puts 'Retrying...'
    retry
  end

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
count = 0

while path = queue.shift
  node = path.last

  count += 1
  puts "(#{count}/#{queue.length})[#{path.length}]\t#{node}"
  links = get_links(node)

  if links.include? BACON
    puts '*' * 20, path, BACON
    break
  end

  links.select! do |link|
    !seen[link].tap { seen[link] = true }
  end

  queue += links.map { |link| path + [link] }
end

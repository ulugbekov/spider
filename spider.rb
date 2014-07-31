#! /usr/bin/env ruby

begin
	require 'mechanize' 
rescue LoadError
	puts "installing mechanize :)"
	system('gem install "mechanize" --no-ri --no-rdoc')
end

require 'optparse'
require 'json'

options = {path: "", limit: 10, out: ".", stdout: false}

parser = OptionParser.new do |opts|
	opts.banner = "Usage: ruby spider.rb [options]"
	opts.on('-p', '--path path', 'Path, Required') do |path|
		options[:path] = path;
	end

	opts.on('-l', '--limit limit', 'Limit, Default 10') do |limit|
		options[:limit] = limit.to_i;
	end

	opts.on('-o', '--out out', 'Out, Default current path') do |out|
		destination = File.expand_path(out);
		unless File.exists?(destination) && File.directory?(destination)
			puts "Please give correct output path"
			exit(0)
		end
		options[:out] = out
	end

	opts.on('-s', '--stdout', 'Stdout, Default false') do
		options[:stdout] = true;
	end

	opts.on('-h', '--help', 'Help') do
		puts opts
		exit(0)
	end
end

parser.parse!

puts options

#Lets assume default port is 80 for regex

r=/(?:[-A-Za-z0-9]+\.)+[A-Za-z]{2,6}$/

while !(options[:path].match r)
	print 'Enter Path: '
	options[:path] = gets.chomp
end



url = options[:path]
limit = options[:limit]
destination = options[:out]
std = options[:stdout]
documents = []

#Apparently we don't know if server supports ssl
unless	url.start_with?("http")
	url = "http://" + url
end

Mechanize.new.get(url).search("a").first(limit).each do |link|
	href = link.attributes["href"].value
	if	href.start_with? "http"
		title = Mechanize.new.get(href).search("title").text
		documents << {:"#{href}" =>  title}
	else
		title = Mechanize.new.get(url + href).search("title").text
		documents << {:"#{url + href}" => title}
	end
end

if std
	puts documents.to_json
else
	File.open(destination + "/documents.json", "w+") do |f|
		f << documents.to_json
	end
end





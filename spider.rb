#! /usr/bin/env ruby

begin
	require 'mechanize' 
rescue LoadError
	puts "installing mechanize :)"
	system('gem install "mechanize" --no-ri --no-rdoc')
end

require 'optparse'

options = {path: nil, limit: 10, out: ".", stdout: false}

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
#! /usr/bin/env ruby

begin
	require 'mechanize' 
rescue LoadError
	puts "installing mechanize :)"
	system('gem install "mechanize" --no-ri --no-rdoc')
end
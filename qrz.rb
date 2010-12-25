#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'xmlsimple'
require 'cgi'

class QRZ

	attr_accessor :callsign, :username, :password, :key
	attr_reader   :session, :listing, :bio, :bio_file, :dxcc

	QRZ_URL = 'http://www.qrz.com/xml'
	AGENT = 'ruby-gem-qrz-callbook-0.0.1'

	def initialize(args={})
		@callsign = args['callsign']
		@username = args['username']
		@password = args['password']
		@key = args['key']
		@callsign = args['callsign']
	end

	def login
		url = "#{QRZ_URL}/bin/xml?username=#{@username};password=#{@password};agent=#{AGENT}"
		xml = open(url).read
		content  = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		@key = @session['Key']
	end

	def get_listing
		url = "#{QRZ_URL}/bin/xml?s=#{@key};callsign=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		@listing = content['Callsign']			
	end

	def get_bio
		url = "#{QRZ_URL}/bin/xml?s=#{@key};bio=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		@bio = content['Bio']
	end

	def get_bio_file
		url = "#{@bio['bio']}";
		content = open(url).read
		content = content.gsub(/&nbsp;/," ").gsub(/<.*?>/m, '').gsub(%r{(\n\s*){2}}, "\n\n")
		@bio_file = CGI.unescapeHTML(content)
	end

	def get_dxcc
		url = "#{QRZ_URL}/bin/xml?s=#{@key};dxcc=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		@dxcc = content['DXCC']	
	end

end # class QRZ

qrz = QRZ.new({
		'callsign' => 'n8qq',
		'username' => 'n8qq',
		'password' => 'bamcqrz'
})

qrz.login
qrz.get_bio
qrz.get_bio_file
puts qrz.bio_file

#qrz.dxcc.each_pair { |key, value| puts "#{key} = #{value}" }


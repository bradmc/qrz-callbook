require 'rubygems'
require 'open-uri'
require 'xmlsimple'
require 'cgi'

class QRZCallbook

	@@VERSION = '0.0.1'

	class SessionError < StandardError; end

	attr_accessor :callsign, :username, :password, :key
	attr_reader   :session, :listing, :bio, :bio_file, :dxcc

	QRZ_URL = 'http://www.qrz.com/xml'
	AGENT = "ruby-gem-qrz-callbook-#{@@VERSION}"

	def initialize(args={})
		@callsign = args['callsign']
		@username = args['username']
		@password = args['password']
		@key = args['key']
		raise "A QRZ API subscription username is required." if @username.to_s.empty?
		raise "A QRZ API subscription password is required." if @password.to_s.empty?
	end

	def login
		raise "A QRZ API subscription username is required." if @username.to_s.empty?
		raise "A QRZ API subscription password is required." if @password.to_s.empty?
		url = "#{QRZ_URL}/bin/xml?username=#{@username};password=#{@password};agent=#{AGENT}"
		xml = open(url).read
		content  = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		raise SessionError, @session['Error'] if @session['Error']
		@key = @session['Key']
		raise SessionError, "Unknown Error: Could not retrieve session key." if @session['Key'].to_s.empty?
	end

	def get_listing
		raise "An amateur radio callsign is required to retrieve data." if @callsign.to_s.empty?
		login if @key.to_s.empty?
		url = "#{QRZ_URL}/bin/xml?s=#{@key};callsign=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		raise SessionError, @session['Error'] if @session['Error']
		@listing = content['Callsign']			
	end

	def get_bio
		raise "An amateur radio callsign is required to retrieve data." if @callsign.to_s.empty?
		login if @key.to_s.empty?
		url = "#{QRZ_URL}/bin/xml?s=#{@key};bio=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		if @session['Error'] =~ /not found/i
			@bio = {}
			return
		end
		raise SessionError, @session['Error'] if @session['Error']
		@bio = content['Bio']
	end

	def get_bio_file
		get_bio if @bio.to_s.empty?
		if @bio['bio'].to_s.empty?
			@bio_file = ''
			return;
		end
		url = "#{@bio['bio']}";
		content = open(url).read
		content = content.gsub(/&nbsp;/," ").gsub(/<.*?>/m, '').gsub(%r{(\n\s*){2}}, "\n\n")
		@bio_file = CGI.unescapeHTML(content)
	end

	def get_dxcc
		raise "An amateur radio callsign is required to retrieve data." if @callsign.to_s.empty?
		login if @key.to_s.empty?
		url = "#{QRZ_URL}/bin/xml?s=#{@key};dxcc=#{@callsign}";
		xml = open(url).read
		content = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		@session = content['Session']
		raise SessionError, @session['Error'] if @session['Error']
		@dxcc = content['DXCC']	
	end

end # class QRZCallbook



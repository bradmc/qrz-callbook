#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'xmlsimple' # docs at http://xml-simple.rubyforge.org/

class Qrz

	def get_birth(callsign)
		callsign = "n8qq"
		qrz_base_url = 'http://www.qrz.com/xml'
		url = "#{qrz_base_url}/bin/xml?username=n8qq;password=bamcqrz;agent=qrz_gem_test0.0.0"
		xml = open(url).read
		session = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		key = session['Session']['Key']
		url = "#{qrz_base_url}/bin/xml?s=#{key};callsign=#{callsign}"	
		xml = open(url).read
		calldata = XmlSimple.xml_in( xml, { 'ForceArray' => false } )
		return calldata['Callsign']['born']
	end

end # class Qrz

call = Qrz.new
puts call.get_birth('n8qq')

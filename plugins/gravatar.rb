# include the MD5 gem, this should be part of a standard ruby install
require 'digest/md5'
require 'net/http'
require 'json'

module Jekyll

	class Gravatar < Liquid::Tag



		def initialize(tag_name, text, tokens)
		  super
			@cache = Hash.new
		end

		def get_profile(hash)
			return nil unless hash.is_a? String
			# get JSON for profile
			if @cache.key?(hash)
				res = cache.fetch(hash)
			else
				uri = URI("https://en.gravatar.com/#{hash}.json")
				res = Net::HTTP.get_response(uri)
			end

			if not res.is_a?(Net::HTTPSuccess)
				return nil
			else
				@cache[hash] = res
				# parse JSON and return simplified hash of information
				profile_string = res.body
				profile = JSON.parse(profile_string)
				name = profile.fetch("entry")[0].fetch("name").key?("formatted") ?
					profile.fetch("entry")[0].fetch("name").fetch("formatted") :
					profile.fetch("entry")[0].fetch("username")
				location = profile.fetch("entry")[0].key?("currentLocation") ?
					profile.fetch("entry")[0].fetch("currentLocation") :
					""
				profile_url = profile.fetch("entry")[0].fetch("profileUrl")
				about = profile.fetch("entry")[0].key?("aboutMe") ?
					profile.fetch("entry")[0].fetch("aboutMe") :
					""
				info = Hash.new
				info[:name] = name
				info[:location] = location
				info[:url] = profile_url
		  	info[:about] = about
				return info
			end
		end

		def build_hovercard(profile)
			html = "<div class='gcard grofile' style='position: relative; min-width:210px; margin: 0px auto;'>" +
				"<div class='grav-inner gcard-about'>" +
				"<div class='grav-grav' style='width: 100px; margin: 0px auto 10px; float: none;'>" +
				"<a href='#{profile[:url]}' target='_blank'>"+
				"<img src='#{profile[:image]}' width='100' height='100' style='border: none'>" +
				"</a>" +
				"</div>" +
				"<div class='grav-info' style='float: none; margin: 0px auto; style: auto;'>" +
				"<h4><a href=#{profile[:url]}' target='_blank'>#{profile[:name]}</a></h4>" +
				"<p class='grav-loc'>#{profile[:location]}</p>" +
				"<p class='grav-about'>#{profile[:about]}</p>" +
				"<div class='grav-view-complete-button'>" +
				"<a href='#{profile[:url]}' target='_blank' class='grav-view-complete'>View Compelete Profile</a>" +
				"</div>" +
				"</div>" +
				"<div style='clear:both'></div>" +
				"</div>" +
				"<div class='grav-cardarrow'></div>" +
				"<div class='grav-tag'><a href='https://gravatar.com' title='Powered by Gravatar.com'" +
			    "target='_blank'>&nbsp;</a></div>"
			return html
		end


		def render(context)
			# get the site config variables
			site_config = context.registers[:site].config
			# get blog author
			author = site_config['author']

			# get the email address from the site config
			email_address = site_config['gravatar_email']
			# change the email address to all lowercase
			email_address = email_address.downcase

			# create an md5 hash from the email address
			gravatar_hash = Digest::MD5.hexdigest(email_address)

			# get profile info
			profile = get_profile(gravatar_hash)

			# compile the full Gravatar URL
			image_src = "https://www.gravatar.com/avatar/#{gravatar_hash}"

			profile[:image] = image_src
			# output the profile hash to access in template
			return build_hovercard(profile)
		end

	end

end

# register the "gravatar_image" tag
Liquid::Template.register_tag('gravatar_image', Jekyll::Gravatar)
class Shortener
	def self.generate_short_url(original_url)
		base_url = find_base_url(original_url)
		all_urls = eval($redis.get('urls'))
		@short_url = nil
		@entry = nil
		if all_urls.present?
			all_urls.each do |urls|
				if urls["original_url"].eql?(original_url) || urls["final_url"].eql?(base_url)
					@short_url = urls["short_url"]
					@entry = 1
				end
			end
		end
		@short_url ||= ([*('a'..'z'),*('0'..'9')]).sample(6).join
		return [@short_url,@entry]
	end

	def self.find_base_url(original_url)
		original_url.strip!
		final_url = original_url.downcase.gsub(/(https?:\/\/)|(www\.)/,"")
		final_url = "http://#{final_url}"
	end
end

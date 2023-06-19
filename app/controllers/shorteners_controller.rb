class ShortenersController < ApplicationController
	before_action :find_urls

  def index
  end

  def new
  end

  def create
  	@urls ||= []
  	@url = {}
  	@url["original_url"] = params["original_url"]
  	if @url["original_url"].present?
	  	generated_short_url = Shortener.generate_short_url(@url["original_url"])
	  	@url["short_url"] = generated_short_url[0]
	  	@url["final_url"] = Shortener.find_base_url(@url["original_url"])
		if @urls.push(@url) && generated_short_url[1].nil?
			$redis.set("urls",@urls)
			redirect_to shortener_path(@url["short_url"])
		else
			flash[:error] = "Unable to shortened this url. pleasetry again"
			redirect_to new_shortener_path
		end
	end
  end

  def show
  	@url = @urls.last
  	request_base_url = request.host_with_port
  	@original_url = @url["original_url"]
  	@short_url = request_base_url + '/' + @url["short_url"]
  end

  def destroy
  	@urls.delete_if{|x| x["short_url"].eql?(params[:short_url])}
  	$redis.set("urls",@urls)
  	redirect_to shorteners_path
  end

  private
  def find_urls
  	fetch_urls = $redis.get("urls")
  	@urls = eval(fetch_urls)
  end
end

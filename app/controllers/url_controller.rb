class UrlController < ApplicationController

  def create
    url = Url.new(url_params)
    shorter_url = generate_shortened_url(url.original_url)
    url.short_url = shorter_url
    if url.save
      render json: { original_url: url.original_url, short_url: url.short_url }, status: :created
    else
      render json: {error: 'error'}
    end
  end


  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def generate_shortened_url(url)
    url = 'http://cybrl/'
    chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
    uniq_shortened_key = 6.times.map{chars.sample}.join
    url << uniq_shortened_key
    url
  end
end

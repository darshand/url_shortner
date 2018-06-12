class UrlController < ApplicationController

  # Accept a long incoming url
  # sanitize for unwanted chars
  # check for duplicate entry
  # generate shorter url
  # save and render to client
  def create
    url = Url.new
    sanitized_url = sanitize(url_create_params)
    url.original_url = sanitized_url
    if duplicate?(sanitized_url)
      render json: { message: 'URL already exist' }, status: :bad_request
    else
      url.short_url = shortened_url(sanitized_url)
      if url.save
        render json: { original_url: url.original_url, short_url: url.short_url }, status: :created
      else
        render json: { error: 'error' }, status: :bad_request
      end
    end
  end

  # accept a short url
  # search for existence
  def find_original_url
    url = Url.find_by_short_url(params[:short_url])
    if url.present?
      render json: { status: 'success', original_url: url.original_url }, status: :ok
    else
      render json: { error: 'url not found' }, status: :not_found
    end
  end

  private

  def url_create_params
    params.require(:url).permit(:original_url)
  end

  # generate a random uniq key of a-z A-Z 0-9
  # append to a base url
  def shortened_url(url)
    url = 'http://cybrl/'
    chars = ['0'..'9','A'..'Z','a'..'z'].map(&:to_a).flatten
    uniq_shortened_key = 6.times.map{chars.sample}.join
    url << uniq_shortened_key
    url
  end

  def sanitize(url)
    # sanitize incoming request by removing extra chars and conflicts by www and https
    url = url[:original_url].strip.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    "http://#{url}"
  end

  def duplicate?(url)
    url = Url.find_by_original_url(url)
    return true if url.present?
    false
  end
end

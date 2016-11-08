# app.rb
require 'sinatra'
require './gong'
require 'httparty'

class GongApp < Sinatra::Base
  REDIRECT_URI = 'http://0.0.0.0:9292'.freeze
  attr_reader :gong
  def initialize
    super
    @gong = SpotifyGong.new
  end

  get '/' do
    resp = {}
    if params['code']
      resp = HTTParty.post(
        "https://accounts.spotify.com/api/token",
        :body => {
          "grant_type" => "authorization_code",
          "code" => params['code'],
          "redirect_uri" => "#{REDIRECT_URI}",
          "client_id" => @gong.client_id,
          "client_secret" => @gong.client_secret
        }
      )
    end
    @gong.token = resp['access_token']
    @gong.refresh_token = resp['refresh_token']
    "OK!"
  end

  post '/gong_current' do
    if !!@gong.refresh_token
      resp = HTTParty.post(
        "https://accounts.spotify.com/api/token",
        :body => {
          "grant_type" => "refresh_token",
          "refresh_token" => @gong.refresh_token,
          "client_id" => @gong.client_id,
          "client_secret" => @gong.client_secret
        }
      )
      if resp["access_token"]
        @gong.token = resp["access_token"]
        result = @gong.gong_current_track
      end
    end
    result
  end

  get '/init' do
    @gong._get_auth_alt
  end
end

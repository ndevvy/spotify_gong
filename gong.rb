#!/usr/bin/env ruby
require 'fileutils'
require 'httparty'
require 'json'

class SpotifyGong
  REDIRECT_URI = 'http://0.0.0.0:9292'.freeze
  SCOPES = %w(user-read-private playlist-read-private playlist-modify-public playlist-modify-private playlist-read-collaborative)
  attr_accessor :token, :refresh_token
  attr_reader :client_id, :client_secret

  def initialize
    f = File.read('./config.json')
    hash = JSON.parse(f)
    @code = hash["code"]
    @username = hash["username"]
    @client_id = hash["client_id"]
    @client_secret = hash["client_secret"]
  end

  def gong_current_track
    playlists = _get_all_playlists
    current_track = _get_current_track.strip
    playlists_removed = []
    playlists.each { |p|
      if _remove_track_from_playlist(current_track, p["id"])
        playlists_removed << p
      end
    }
    "#{current_track} removed from #{playlists_removed.count} playlists"
  end

  def _remove_track_from_playlist(track_id, playlist_id)
    query = {
      "uri" => track_id
    }
    HTTParty.delete(
      "https://api.spotify.com/v1/users/#{username}/playlists/#{playlist_id}/tracks",
      :query => query,
      :headers => {"Authorization" => "Bearer #{@token}"}
    )
  end

  def _get_all_playlists
    HTTParty.get(
      "https://api.spotify.com/v1/users/#{@username}/playlists",
      :headers => {"Authorization" => "Bearer #{@token}"}
    )
  end

  def _get_current_track
    `osascript -e 'tell application "Spotify" to id of current track as string'`
  end

  def _get_auth
    HTTParty.get("https://accounts.spotify.com/authorize?client_id=#{@client_id}&client_secret=#{@client_secret}&response_type=code&redirect_uri=#{REDIRECT_URI}&scope=#{SCOPES.join(' ')}")
  end

  def _get_auth_alt
    `open "https://accounts.spotify.com/authorize?client_id=#{@client_id}&client_secret=#{@client_secret}&response_type=code&redirect_uri=#{REDIRECT_URI}&scope=#{SCOPES.join(' ')}"`
  end
end

if __FILE__ == $0
  gong = SpotifyGong.new
  gong.gong_current_track
end

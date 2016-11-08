# Spotify Gong
I wrote this because I wanted to be able to remove songs from my Spotify playlists quickly, from the command line.  

## How to use
**Plan A: Don't.** Instead try [shpotify](https://github.com/hnarayanan/shpotify) if you want to do simple track control, or the [Alfred Spotify Mini Player](http://alfred-spotify-mini-player.com/) if you want to do lots of other stuff.  The latter is a very cool workflow, though it requires a bit of setup wrangling of its own.
**Plan B: OK, fine**. If you really want to use this:

**Installation**
  - Clone this repo, cd into the directory, and `bundle install`
  - [Add a new app](https://developer.spotify.com/my-applications/#!/) on Spotify.  Call it whatever.  
  - Add a redirect URI to your app, `http://localhost:9292` (be sure to save)
  - In the app directory, create your own `config.json` with the keys `client_id`, `client_secret`, and `username`. Get the first two from your app page as created in step 2 above.

**To run**
  - Run `rackup` from the app directory to start the server & visit `http://localhost:9292/init` to authorize Spotify.
  - You can now make a post request to `http://localhost:9292/gong_current` and it will skip the current track and remove it from *all* your playlists.  If you want, add an alias like `alias gong!="curl -X POST http://0.0.0.0:9292/gong_current -d ''"
` 

## To do
- [ ] rewrite in node
- [ ] add some other commands


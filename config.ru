require 'bundler'
Bundler.require

require './app'
require 'sinatra/reloader'

run IdeaBoxApp

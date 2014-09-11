ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'
require 'nokogiri'

require_relative '../lib/app'

describe IdeaBoxApp do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it "has a heading" do
    get '/'
    html = Nokogiri::HTML(last_response.body)

    assert last_response.ok?
    assert_equal "IdeaBox", html.css('h1').text
  end

  it "returns group names" do
    get '/groups'
    html = Nokogiri::HTML(last_response.body)

    assert last_response.ok?
    assert_equal "Edit Groups", html.css('h1').text
  end

  # it "tells you look nice today" do
  #   get '/'
  #   html = Nokogiri::HTML(last_response.body)

  #   assert last_response.ok?
  #   assert_equal "You look nice today!", html.css('.message').text
  # end

  it "can create an idea" do
    post '/', :title =>"test_title", :description =>"test_description", :tags =>"test_tag", :group => "Default"
    html = Nokogiri::HTML(last_response.body)

    assert last_response.ok?
    assert_equal "test_title", html.css('table').text
  end

  Minitest.after_run { File.delete('../db/ideabox-test') }

end

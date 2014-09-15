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

  it "can search my ideas"

  it "can display existing ideas"

  it "gives me a form to add a new idea" do
    get '/'

    html = Nokogiri::HTML(last_response.body)

    assert html.at_css('form[action="/"]').at_css('textarea[name="idea[description]"]')
  end


  # it "can create an idea" do
  #   post '/', { idea: { description: 'some description', title: 'some title'}}
  #   html = Nokogiri::HTML(last_response.body)

  #   assert last_response.ok?
  #   assert_equal "test_title", html.css('table').text
  # end

  #Minitest.after_run { File.delete('../db/ideabox-test') }

end

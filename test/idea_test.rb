require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require_relative '../lib/idea_box/idea'

describe Idea do

	def title() 'some title' end
	def description() 'some description' end

	it 'has a title, description, rank, id, and filename' do
		idea = Idea.new('title'=> title, 'description' =>description)

		assert_equal idea.title, title
		assert_equal idea.description, description
	end

	it 'determines its comparability by its rank --higher is better'
	it 'renders its attributes when it calls to_h'
	it 'increments its rank when liked'
	it 'subtracts from rank when disliked'
end

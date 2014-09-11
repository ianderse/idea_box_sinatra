class Idea
	include Comparable

	attr_reader :title, :description, :rank, :id, :tags, :group, :user

	def initialize(attributes = {})
	  @title 			 = attributes["title"]
	  @description = attributes["description"]
	  @rank 		   = attributes["rank"] || 0
	  @id 				 = attributes["id"]
	  @tags				 = split(attributes["tags"]).sort
	  @group       = attributes["group"]
	  @user				 = attributes["user"] || ''
	end

	def split(tag)

		if tag.nil?
			['']
		elsif tag.empty?
			['']
		elsif tag.is_a?(Array)
			tag
		else
			tag.delete(' ').split(',')
		end
	end

	def to_h
		{
			"title" => title,
			"description" => description,
			"rank" => rank,
			"tags" => tags,
			"group" => group,
			"user"  => user
		}
	end

	def like!
		@rank += 1
	end

	def dislike!
		@rank -= 1
	end

	def <=>(other)
		other.rank <=> rank
	end

end

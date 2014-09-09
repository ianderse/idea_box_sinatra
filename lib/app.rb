require 'bundler'
require 'idea_box'

Bundler.require

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  get '/tag_sort' do
    erb :index, locals: {ideas: IdeaStore.all.sort_by {|idea| idea.tags[0]}, idea: Idea.new(params)}
  end

  post '/' do
  	IdeaStore.create(params[:idea])
    redirect '/'
	end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/dislike' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.dislike!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/:tag' do |tag|
    erb :index, locals: {ideas: IdeaStore.all.find_all {|idea| idea.tags.include?(tag)}, idea: Idea.new(params)}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

end

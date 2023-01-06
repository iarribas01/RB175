require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?
require "yaml"

before do
  @contents = File.readlines("data/toc.txt")
  @users = YAML.load_file("users.yaml")
end

helpers do
  def slugify(text)
    text.downcase.gsub(/\s+/, "-").gsub([/[^\w-]/], "")
  end

  def in_paragraphs(chapter)
    chapter.split("\n\n").each_with_index.map do |paragraph, index|
      "<p id=\"paragraph#{index}\">#{paragraph}</p>"
    end.join
  end

  def bold_query(chapter, query)
    chapter.gsub(query, "<strong>#{query}</strong>")
  end

  def num_interests
    counter = 0
    @users.each do |user|
      counter += user[1][:interests].length
    end
    counter
  end
end

not_found do
  redirect "/"
end

get "/" do
  redirect "/users"
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/users" do
  erb :users
end

get "/users/:name" do
  @users.each do |user|
    if params[:name] == user[0].to_s
      @user = user
      break
    end
  end
  erb :personal, layout: :users_layout
end

get "/search" do
  @results = chapters_matching(params[:query])

  erb :search
end

get "/chapters/:number" do
  @num = params["number"].to_i

  redirect "/" unless (1..@contents.size).cover? @num

  @title = "Chapter #{@num}"
  @chapter_title = @contents[@num - 1]
  @chapter = File.read("data/chp#{@num}.txt")
  erb :chapter
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

# returns paragraph num where query is located
def loc(query, chapter)
  return if !query
  temp = chapter.split("query")
  temp[0] 
end
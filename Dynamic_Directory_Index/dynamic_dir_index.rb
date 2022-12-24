require 'sinatra'
require 'sinatra/reloader'
require "tilt/erubis"

get "/" do
  @filenames = Dir.entries("public").select {|f| File.file?(File.join("public", f))}
  @sort_order = params["sort"]

  @sort_order ||= "ascending"

  case @sort_order
  when "ascending" then @filenames.sort!
  when "descending" then @filenames.sort!.reverse!
  end

  erb :main
end

get "/public/*" do |path|
  # put code to read file here.
  @file = "public/#{path}"
  erb :file
end
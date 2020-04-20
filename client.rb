require 'base64'
require 'httparty'

puts "Enter Guild ID:"
@guild_id = gets.chomp
puts "Enter bot API key"
@bot_key = gets.chomp
puts "Enter path"
@path = gets.chomp

def run
  Dir.foreach(@path) do |filename|
    next if filename == "." or filename == ".." or filename == ".DS_Store"
    encoded_image = encode_image(filename)
    filename = get_file_name(filename)
    post(filename,encoded_image)
  end
end

def post(filename,encoded_image)
  response = HTTParty.post("https://discordapp.com/api//guilds/#{@guild_id}/emojis",
                           :body => { :name => filename, :image => "data:image/png;base64," +  encoded_image}.to_json,
                           :headers => { "Authorization" => @bot_key, "Content-Type" => "application/json"})
  response
end

def encode_image(filename)
  Base64.strict_encode64(File.open(@path + filename.to_s).read)
end

def get_file_name(filename)
  File.basename(filename,File.extname(filename))
end

run

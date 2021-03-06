require 'sinatra'
require 'RMagick'
include Magick

get '/' do
    html :index
end

def html(view)
      File.read(File.join('public', "#{view.to_s}.html"))
end

get '/:meme/:text' do
    content_type 'image/jpg'

    text = word_wrap params['text']
    filename = params['meme']
    puts filename
    write_in_image(text, "public/static/pictures/" + filename + ".jpg")
end

def write_in_image(text, img_path)

    img = Magick::Image.read(img_path).first
    drawing = Magick::Draw.new

    position = 0
    text.split("\n").each do |row|
        drawing.annotate(img, 0, 0, 1, position += 30, row) do
            self.font = 'Verdana'
            self.pointsize = 30
            self.fill = 'white'
            self.font_weight = Magick::BoldWeight
        end
    end

    img.format = 'jpg'
    img.to_blob  
end


def word_wrap(text, columns = 40)
  text.split("\n").collect do |line|
    line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
  end * "\n"
end

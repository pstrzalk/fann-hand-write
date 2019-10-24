require 'rmagick'

class HandWrittenImage
  def initialize(path)
    @path = path
  end

  def to_a
    @to_a ||= image.get_pixels(0, 0, 28, 28)
                   .map { |p| (p.red + p.green + p.blue) / 3 / 65_535.0 }
                   .map { |c| c > 0.2 ? 1 : 0 }
  end

  def to_s
    Array.new(28) do |i|
      from = i * 28
      to = from + 27
      to_a[from..to].map { |c| c > 0.2 ? 1 : 0 }.join
    end.join("\n")
  end

  private

  attr_reader :path

  def image
    @image ||= Magick::Image.read(path).first
  end
end

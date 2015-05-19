class Floor

  attr_reader(:width, :height, :map)

  def initialize (attributes)
    @width = attributes[:width]
    @height = attributes[:height]
    @map = Array.new(@width)
    @map.each_index() do |index|
      @map[index] = Array.new(@height, false)
    end
  end

end

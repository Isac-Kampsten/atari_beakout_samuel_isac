class Block

    attr_accessor :x, :y, :blocks

    def initialize(x,y)
        @x = x
        @y = y
        @image = Gosu::Image.new("./imgs/block1.png")
    end

    def update
     


    end

    def draw
        @image.draw(@x, @y,1)
    end
    


end
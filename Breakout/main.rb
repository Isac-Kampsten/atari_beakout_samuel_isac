require "gosu"
require_relative "balls.rb"
require_relative "block.rb"
require "csv"

class Window < Gosu::Window

    def initialize
        super(1920,1080, true)
        @backgroundimg = Gosu::Image.new("./imgs/back.png")
        @playerimg = Gosu::Image.new("./imgs/player_paddle.png")
        @player_posx = 860
        @player_posy = 900
        @bounce = Gosu::Sample.new("./Audio/laser1.wav")

        @ball1 = Ball.new(920,520)
        @ball1TopLeftx = @x
        @ball1TopLefty = @y
        create_level()

    end
    
    def create_level
        start_xpos = 20
        start_ypos = 20
        @blocks = []
        
        level = CSV.read("./banor/level1.csv")
        level.each_with_index do |row, y|
            row.each_with_index do |block, x|
                p "y är #{y} och x är #{x} och värdet är #{block}"

                if block == "#"
                    @blocks << Block.new(start_xpos + (200 * x), start_ypos + (40 * y))
                end
            end
            
        end

    end

    def update
        if self.button_down?(Gosu::KbLeft) == true && @player_posx > 0
            @player_posx -= 8
        end
        if self.button_down?(Gosu::KbRight) == true && @player_posx < 1720
            @player_posx += 8
        end

        @ball1.update()
        
        @blocks.each do |block|
            block.update()
        end

        if @player_posy - (@ball1.y + 16) <= 2 && @ball1.x < @player_posx+200 && @ball1.x+16 > @player_posx
            @ball1.y_vel *= -1
            @bounce.play()
        end

    end
    
    def draw
        @backgroundimg.draw(0,0)
        @playerimg.draw(@player_posx,@player_posy)
        @ball1.draw()
        

        @blocks.each do |block|
            block.draw()
        end
    end

end



 
win = Window.new
win.show
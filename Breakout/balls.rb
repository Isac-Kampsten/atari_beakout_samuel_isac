class Ball

    attr_accessor :x, :y, :y_vel, :x_vel

    def initialize(x,y)
        @x = x
        @y = y
        @x_vel = 4
        @y_vel = 4
        @image = Gosu::Image.new("./imgs/ball.png")
        @bounce = Gosu::Sample.new("./Audio/laser1.wav")
    end

    def update
        
        #vägg kollisoner
        if @y > 1080
            #gameover
            exit()
        elsif @y <= 0 
            @y_vel *= -1
            @y = 5
            @bounce.play()
        else
            @y -= @y_vel
        end

        if @x < 1 
            @x_vel *= -1
            @x = 5
            @bounce.play()
        elsif @x > 1904
            @x_vel *= -1
            @x -= 5
            @bounce.play()
        else
            @x -= @x_vel
        end

    end

    def draw
        @image.draw(@x, @y,1)
    end
    
end
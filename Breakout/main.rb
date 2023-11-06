# frozen_string_literal: true

require 'gosu'
require_relative 'balls'
require_relative 'block'
require 'csv'

class Window < Gosu::Window
  def initialize
    super(1920, 1080, true)
    @backgroundimg = Gosu::Image.new('./imgs/back.png')
    @playerimg = Gosu::Image.new('./imgs/player_paddle.png')
    @player_posx = 860
    @player_posy = 900
    @bounce = Gosu::Sample.new('./Audio/laser1.wav')

    @ball1 = Ball.new(920, 520)
    @ball1TopLeftx = @x
    @ball1TopLefty = @y
    create_level
  end

  def create_level
    start_xpos = 20
    start_ypos = 20
    @blocks = []

    level = CSV.read('./banor/level2.csv')
    level.each_with_index do |row, y|
      row.each_with_index do |block, x|
        p "y är #{y} och x är #{x} och värdet är #{block}"

        @blocks << Block.new(start_xpos + (287 * x), start_ypos + (120 * y)) if block == '#'
      end
    end
  end

  def update
    @player_posx -= 8 if button_down?(Gosu::KbLeft) == true && @player_posx.positive?
    @player_posx += 8 if button_down?(Gosu::KbRight) == true && @player_posx < 1720

    @ball1.update

    @blocks.each(&:update)

    if @player_posy - (@ball1.y + 16) <= 2 && @ball1.x < @player_posx + 200 && @ball1.x + 16 > @player_posx
      @ball1.y_vel *= -1
      if button_down?(Gosu::KbLeft) == true
        @ball1.x_vel = 4
      elsif button_down?(Gosu::KbRight) == true
        @ball1.x_vel = - 4
      end

      @bounce.play
    end

    @blocks.each_with_index do |block, index|
      if (block.y + 50) - @ball1.y <= 4 && ((block.y + 50) - @ball1.y).positive? && @ball1.x < block.x + 160 && @ball1.x + 16 > block.x
        @ball1.y_vel *= -1

        @blocks.delete_at(index)
        @bounce.play

      elsif @ball1.y > block.y && @ball1.y < block.y + 50
        if block.x - (@ball1.x + 16) <= 4 && (block.x - (@ball1.x + 16)).positive?
          @ball1.x_vel *= -1
          @bounce.play
          @blocks.delete_at(index)
        elsif @ball1.x - (block.x + 160) <= 4 && (@ball1.x - (block.x + 160)).positive?
          @ball1.x_vel *= -1
          @bounce.play
          @blocks.delete_at(index)
        end
      end
    end
  end

  def draw
    @backgroundimg.draw(0, 0)
    @playerimg.draw(@player_posx, @player_posy)
    @ball1.draw


    @blocks.each(&:draw)
  end
end




win = Window.new
win.show

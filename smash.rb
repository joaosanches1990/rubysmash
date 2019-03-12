require 'gosu'

class Game < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Ruby Smash"
    @image = Gosu::Image.new('media/ruby.png')
    @x = 200
    @y = 200
    @width = 100
    @height = 75
    @vel_x = 5
    @vel_y = 5
    @visible = 0
    @hammer = Gosu::Image.new('media/thorhammer2.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true #gameworking
    @start_time = 0
    @gameover = Gosu::Song.new('media/gameover.mp3')
    @soundtrack = Gosu::Song.new('media/crazyfrog.wav')
    @soundtrack.play(true)
  end


  def draw
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    @hammer.draw(mouse_x - 55, mouse_y - 60, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    @font.draw_text(@score.to_s, 650, 50, 2)
    @font.draw_text(@time_left.to_s, 50, 50, 2)
    unless @playing
      @font.draw_text("Game Over !!!", 300, 300, 3)
      @visible = 20
      @font.draw_text("Press Space Bar to Play", 200, 150, 3)
    end

  end

  def update
    if @playing
      @x += @vel_x
      @y += @vel_y
      @vel_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @vel_y *= -1 if @y + @width / 2 > 600 || @y - @width / 2 < 0
      @visible -= 1
      @visible = 30 if @visible < -10 && rand < 0.01
      @time_left = (60 - ((Gosu.milliseconds) - @start_time) / 1000) #timevisible
      @playing = false if @time_left < 1
    else
      @gameover.play
    end

  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 10
        else
          @hit = - 1
          @score -= 5
        end
      end
    else #RESTART
        if (id == Gosu::KbSpace)
          @playing = true
          @visible = -10
          @start_time = Gosu.milliseconds
          @score = 0
        end
    end
    #EXIT
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end

  end
end



window = Game.new
window.show

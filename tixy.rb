require 'gosu'
include Math

$size = 20		# size of the grid
$step = 30		# size of the tile
$dot_scale = 1#0.99		# scale the tile
$center = false		# set 0.0 to the center of the panel

$mode_alpha = false	# use alpha instead of size to modulate objects

#$render = "square"
$render = "circle"

def tixy(t, i, x, y)
  sin(sin((x)/t/4) + cos((y)/t/4) + t) *tan(cos((-x)*t/4) + cos((y)*t/4) + t)*cos(t)
end

class Tutorial < Gosu::Window
  def initialize
    super ($size+1)*$step, ($size+1)*$step
    self.caption = "tixy.rb"
  end
  
  def update
    # ...
  end
  
  def draw
    for x in 0...$size
        for y in 0...$size
            i = x*$size + y;
            
            t = Gosu.milliseconds * 0.001 
            if $center
              f = tixy(t.to_f,i,x-$size/2,y-$size/2)
            else
              f = tixy(t.to_f,i,x,y)
            end

            #crop f to range +-1
            fc = f.abs > 1 ? f.positive? ? 1 : -1 : f

            #calculate quad size
            quad_size = fc*($step)*$dot_scale
            #crop to max size
            if quad_size.abs > $step
              quad_size = quad_size.positive? ? $step : -$step
            end
            if $mode_alpha
              quad_size = $step*$dot_scale
            end

            color = Gosu::Color.new($mode_alpha ? 255*fc.abs : 255, 255, fc.positive? ? 255 : 0, fc.positive? ? 255 : 0)

            #draw
            x_d = (x+1)*$step
            y_d = (y+1)*$step
            if $render == "square"
              Gosu.draw_rect(y_d-quad_size/2,x_d-quad_size/2, quad_size, quad_size, color)
            elsif $render == "circle"
              dot_size = fc.abs*0.01 * $step
              pic = fc.positive? ? Gosu::Image.new("white.png") : Gosu::Image.new("green.png")
              pic.draw(y_d-dot_size*50, x_d-dot_size*50, 0, dot_size, dot_size); #*100/2
            end
        end
    end
  end
end

Tutorial.new.show

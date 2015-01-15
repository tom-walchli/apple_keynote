####################################################################
#                                                                  #
#    Toggle slides from .txt file delimeted by \n----\n            #
#                                                                  #
#    Use:                                                          #
#      - any key to go forward                                     #
#      - 'z' to go back      				                       #
#      - 'a' for auto-mode                                         #
#                                                                  #
####################################################################

require 'terminfo'
 
def measure(dimension,length=1)
  @dimension 	= dimension 	# height or width [ 0 | 1 ]
  @length	= length
#  puts @length
#  puts @dimension
#  puts "ss: #{$screensize[@dimension]}"
  delta = (($screensize[@dimension] - @length) / 2).floor
#  puts "delta: #{delta}"
  return delta
end

def waitForNext
  nextChar = gets.chomp
  if nextChar == 'z'
    toggle(-1)
  elsif nextChar == 'a'
    $autoMode = true
    toggle()
  else 
    toggle()
  end
end

def runAuto
  sleep($sleepDelay)
  if $currIndex == $slides.length - 1
    return
  end
  toggle
  runAuto
end

def toggle(direction=1)
  $currIndex += direction
  if $currIndex < 0 
    $currIndex = 0
  elsif $currIndex > $slides.length - 1
    $currIndex = $slides.length - 1
  end
  selSlide
end  

def selSlide
  display($slides[$currIndex])
end

def display_old(slide)
  t = TermInfo.new(ENV["TERM"], STDOUT)
  $screensize = t.screen_size
  #system "clear" #
  system "cls"
  dY = measure(0)
  dX = measure(1,slide.length)
  t.control ("cuf",dX)
  t.control ("cud",dY)
  puts slide
  print "\n"*(dY-1)
  $autoMode ? runAuto : waitForNext()
end

def display(slide)
  t = TermInfo.new(ENV["TERM"], STDOUT)
  $screensize = t.screen_size
  system "clear" 
#  system "cls"
  dY = measure(0)
  dX = measure(1,slide.length)
  print "\n"*dY
  print " "*dX
  print  slide
  print "\n"*(dY-1)
  $autoMode ? runAuto() : waitForNext()
end

$sleepDelay = 1.5
$currIndex = 0
$slides = IO.read('slides_one_line.txt').split("\n----\n")
$autoMode = false
selSlide


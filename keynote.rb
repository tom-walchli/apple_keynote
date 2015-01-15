####################################################################
#                                                                  #
#    Toggle slides from .txt file delimeted by \n----\n            #
#                                                                  #
#    Use:                                                          #
#      - any key to toggle forward,                                #
#      - 'z' to go back      				                       #
#      - 'a' for auto-mode                                         #
#                                                                  #
####################################################################

require 'terminfo'

$sleepDelay = 1.5
$currIndex = 0
$slides = IO.read('slides_multi_line.txt').split("\n----\n")
$autoMode = false
$screenSize = []

class PrepareSlide
	def self.measure(dimension,length=1)
#		puts "Dim: #{dimension} Length: #{length} "
#		puts $screenSize
		delta = (($screenSize[dimension] - length) / 2).floor
		return delta
	end

	def self.prepare(slide)
		linesArr = slide.split("\n")
		maxLength = (linesArr.max {|a,b| a.length <=> b.length}).length
		dX = self.measure(1,maxLength)
		return " "*dX + linesArr.join("\n" + " "*dX)
	end
end

class RunAuto
	def self.runAuto
		sleep($sleepDelay)
		if $currIndex == $slides.length - 1
			return
		end
		SelectSlide.toggle
		self.runAuto
	end
end

class SelectSlide

	def self.selSlide
		Display.new($slides[$currIndex])
	end

	def self.toggle(direction=1)
		$currIndex += direction
		if $currIndex < 0 
			$currIndex = 0
		elsif $currIndex > $slides.length - 1
			$currIndex = $slides.length - 1
		end
		self.selSlide
	end  

	def self.waitForNext
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
end

class Display
	def initialize(slide)
		display(slide)
	end

	def display(slide)
		t = TermInfo.new(ENV["TERM"], STDOUT)
		$screenSize = t.screen_size
		system "clear" 
		dY = PrepareSlide.measure(0,slide.split("\n").length)
#		PrepareSlide.prepare(slide)
		print "\n"*dY
		print PrepareSlide.prepare(slide)
		print "\n"*(dY-1)
		$autoMode ? RunAuto.runAuto() : SelectSlide.waitForNext()
	end
end

SelectSlide.selSlide







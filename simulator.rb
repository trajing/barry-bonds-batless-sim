require 'ruby-progressbar'
require_relative 'processor.rb'

SIM_TIMES = 1_000_000

PITCH_NOTATION = {
  '+' => "Following pickoff throw by catcher",
  '*' => "Following pitch blocked by catcher",
  '.' => "Play not involving batter",
  '1' => "Pickoff throw to first",
  '2' => "Pickoff throw to second",
  '3' => "Pickoff throw to third",
  '>' => "Runner went on pitch",
  'B' => "Ball",
  'C' => "Called strike",
  'F' => "Foul",
  'H' => "Hit by pitch",
  'I' => "Intentional ball",
  'K' => "Strike (unknown type)",
  'L' => "Foul bunt",
  'M' => "Missed bunt attempt",
  'N' => "No pitch",
  'O' => "Foul tip on bunt",
  'P' => "Pitchout",
  'Q' => "Swinging on pitchout",
  'R' => "Foul ball on pitchout",
  'S' => "Swinging strike",
  'T' => "Foul tip",
  'U' => "Unknown or missed pitch",
  'V' => "Called ball because pitcher went to his mouth",
  'X' => "Ball put into play by batter",
  'Y' => "Ball put into play on pitchout"
}

def swung_pitch_in_strike
  rand(1..1000) >= 192
end

def new_ball_in_strike
  rand(1..1000) >= 588
end

def sim_plate(script)
  strikes = 0
  balls = 0
  script.each_char do |char|
    case char
    when '+', '*', '.', '1', '2', '3', '>'
      next
    when 'B', 'I'
      balls += 1
    when 'C'
      strikes += 1
    when 'F', 'L', 'S', 'T', 'X'
      if swung_pitch_in_strike
        strikes += 1
      else
        balls += 1
      end
    when 'H'
      return 'hit by pitch'
    else
      raise "unrecognized notation #{char}"
    end
    
    if strikes > 2
      return 'strikeout'
    elsif balls > 3
      return 'walk'
    end
  end
  
  # ran off end
  loop do 
    # should slightly underestimate bonds -- hbp chance is not factored in
    if new_ball_in_strike
      strikes += 1
    else
      balls += 1
    end
    
    if strikes > 2
      return 'strikeout'
    elsif balls > 3
      return 'walk'
    end
  end
end

GameResults = Struct.new(:strikeouts, :hbps, :walks) do
  def obp_num
    hbps + walks
  end

  def obp_den
    strikeouts + hbps + walks
  end
end

def sim_game(game)
  strikeouts = hbps = walks = 0
  game.plays.each do |play|
    pitch_result = sim_plate(play.pitch)
    case pitch_result
    when 'strikeout'
      strikeouts += 1
    when 'hit by pitch'
      hbps += 1
    when 'walk'
      walks += 1
    else
      raise "unrecognized pitch result #{pitch_result}"
    end
  end
  GameResults.new(strikeouts, hbps, walks)
end

def sim_season
  results = BONDS_GAMES.map { |game| sim_game game }
  obp_num = results.map { |result| result.obp_num }.inject(:+)
  obp_den = results.map { |result| result.obp_den }.inject(:+)
  obp_num.to_f / obp_den
end

def sim_n_times(iters, &block)
  sum = 0
  bar = ProgressBar.create(title: "Simulating", total: iters)
  iters.times do
    bar.increment
    sum += block.call()
  end
  sum.to_f / iters
end

result = sim_n_times(SIM_TIMES) { sim_season }
puts "Average simulated OBP: #{result}"
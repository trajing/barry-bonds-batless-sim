# # # # # # # # # # # # # # # # # # # # # # # #
# barry bonds batless simulator               #
# with apologies to jon bois                  #
# (or not I guess he asked me to)             #
# https://www.youtube.com/watch?v=JwMfT2cZGHg #
# # # # # # # # # # # # # # # # # # # # # # # #

BARRY_CODE = 'bondb001'
DIRECTORY_PATH = 'Data'
RETROSHEET_EVENT_FILE_REGEXP = /\.ev[an]$/i

GameId = Struct.new(:team, :date, :num) do
  def self.from_string(str)
    team = str[0..2]
    year = str[3..6].to_i
    month = str[7..8].to_i
    day = str[9..10].to_i
    num = str[11].to_i
    date = Time.new(year, month, day)
    GameId.new(team, date, num)
  end
  
  def to_s
    "#{team}#{date.strftime '%Y%m%d'}#{num}"
  end
end
Game = Struct.new(:id, :plays) do
  def filter_plays_by_player(player_id)
    Game.new(id, plays.select { |play| play.player_id == player_id })
  end
end
Play = Struct.new(:player_id, :pitch, :play)

def load_game_data_from_file(file)
  games = []
  file.each_line do |ln|
    info = ln.chomp.split ','
    if info[0] == 'id'
      games << Game.new(GameId.from_string(info[1]), [])
    elsif info[0] == 'play'
      if !games.last.plays.empty? && games.last.plays.last.player_id == info[3]
        games.last.plays.pop
      end
      games.last.plays << Play.new(info[3], info[5], info[6]) unless info[6] == 'NP'
    end
  end
  games
end

def load_retrosheet_data_from_dir(directory)
  all_games = []
  Dir.open(directory) do |dir|
    dir.each_child do |fn| 
      if RETROSHEET_EVENT_FILE_REGEXP =~ fn
        File.open DIRECTORY_PATH + File::SEPARATOR + fn, 'r' do |f|
          all_games.concat load_game_data_from_file(f)
        end
      end
    end
  end
  all_games
end

ALL_GAMES = load_retrosheet_data_from_dir DIRECTORY_PATH

BONDS_GAMES = ALL_GAMES.map { |game| game.filter_plays_by_player BARRY_CODE }.select { |game| game.plays.length > 0 }
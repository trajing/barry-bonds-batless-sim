# # # # # # # # # # # # # # # # # # # # # # # #
# barry bonds batless simulator               #
# with apologies to jon bois                  #
# (or not I guess he asked me to)             #
# https://www.youtube.com/watch?v=JwMfT2cZGHg #
# # # # # # # # # # # # # # # # # # # # # # # #

require 'pry'

BARRY_CODE = 'bondb001'
DIRECTORY_PATH = 'Data'
RETROSHEET_EVENT_FILE_REGEXP = /\.ev[an]$/i

# def appearances_from_file(fn)
#     barry_appearances = []
#     File.open(fn, 'r') do |f|
#         until f.eof?
#             ln = f.gets.chomp.split ','
#             if ln[0] == 'play' && ln[3] == BARRY_CODE
#                 barry_appearances << ln
#             end
#         end
#     end
#     barry_appearances
# end

def load_retrosheet_data_from_dir(directory)
    Dir.open(directory) do |dir|
        dir.each_child do |fn| 
            if RETROSHEET_EVENT_FILE_REGEXP =~ fn
                all_appearances.concat appearances_from_file(DIRECTORY_PATH + File::SEPARATOR + fn)
            end
        end
    end
end

# all_appearances = []
# Dir.open(DIRECTORY_PATH) do |dir|
#     dir.each_child do |fn| 
#         if RETROSHEET_EVENT_FILE_REGEXP =~ fn
#             all_appearances.concat appearances_from_file(DIRECTORY_PATH + File::SEPARATOR + fn)
#         end
#     end
# end
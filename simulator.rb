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
        when '.'
            # . marker for play not involving the batter
            next
        when 'C'
            strikes += 1
        when 'B'
            balls += 1
        when 'S'
            if swung_pitch_in_strike
                strikes += 1
            else
                balls += 1
            end
        when 'F'
            if swung_pitch_in_strike
                strikes += 1
            else
                balls += 1
            end
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
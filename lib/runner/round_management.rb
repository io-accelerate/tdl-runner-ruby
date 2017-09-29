
CHALLENGES_FOLDER = 'challenges'
LAST_FETCHED_ROUND_PATH = "#{CHALLENGES_FOLDER}/XR.txt"


module RoundManagement

  def display_and_save_description(label, description)
    puts "Starting round: #{label}"
    puts description

    output_description = File.open("#{CHALLENGES_FOLDER}/#{label}.txt", 'w')
    output_description << description
    output_description.close
    puts "Challenge description saved to file: #{output_description.path}."

    output_last_round = File.open(LAST_FETCHED_ROUND_PATH, 'w')
    output_last_round << label
    output_last_round.close

    'OK'
  end

  def get_last_fetched_round
    File.read(LAST_FETCHED_ROUND_PATH)
  end

end


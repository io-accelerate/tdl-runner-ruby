require 'unirest'

RECORDING_SYSTEM_ENDPOINT = 'http://localhost:41375'

module RecordingSystem

  def is_running
    begin
      response = Unirest.get RECORDING_SYSTEM_ENDPOINT + '/status'

      if response.code == 200 and response.body.start_with?('OK')
        return true
      end
    rescue StandardError => e
      puts 'Could not reach recording system: ' + e.message
    end

    false
  end


  def notify_event(last_fetched_round, short_name)
    puts "Notify round \"#{last_fetched_round}\", event \"#{short_name}\""

    require_recording = true?(read_from_config_file_with_default(:tdl_require_rec, 'true'))

    if not require_recording
      return
    end

    begin
      response = Unirest.post RECORDING_SYSTEM_ENDPOINT + '/notify',
                              parameters:"#{last_fetched_round}/#{short_name}"

      unless response.code == 200
        puts "Recording system returned code: #{response.code}"
        return
      end

      unless response.body.start_with?('ACK')
        puts "Recording system returned body: #{response.body}"
      end
    rescue StandardError => e
      puts 'Could not reach recording system: ' + e.message
    end
  end

end


require 'sinatra'
require 'json'


post '/event_handler' do
  @payload = JSON.parse(params[:payload])
  @log_file = File.open("server_log.log", "a")
  case request.env['HTTP_X_GITHUB_EVENT']
  when "pull_request"
    if @payload["action"] == "opened"
      process_pull_request(@payload["pull_request"], @log_file)
    end
  end
  @log_file.close
end

helpers do
  def process_pull_request(pull_request, log_file)
	log_file.write("#{pull_request['title']}," + " #{pull_request['body']}," + " " + String(Time.now))
  end
end
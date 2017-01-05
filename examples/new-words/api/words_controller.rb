require 'date'

register do
  def validate(type)
    condition { halt 422 unless send("#{type}_valid?") }
  end
end

helpers do
  def word_valid?
    WordJob.valid?(params[:word])
  end

  def job_id
    Thread.current[:request_id] # X-Request-Id
  end
end

get '/w', auth: :user do
  datetime_after = params[:datetime_after] ||
                   DateTime.new(2016, 12, 5, 21, 40, 0).iso8601 # I've written

  content_type 'application/json'

  WordJob.all(session[:user_id], job_id, datetime_after).to_json
end

post '/w/:word', auth: :user, validate: :word do
  request.body.rewind
  payload = request.body.read

  content_type 'application/json'
  status 201

  WordJob.insert_or_update(session[:user_id], params[:word], payload,
                           job_id).to_json
end

put '/w/:word/learned', auth: :user, validate: :word do
  status 204
  body nil

  WordJob.learned(session[:user_id], params[:word], job_id)
end

delete '/w/:word', auth: :user, validate: :word do
  status 204
  body nil

  WordJob.delete(session[:user_id], params[:word], job_id)
end

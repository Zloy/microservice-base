register do
  def validate(type)
    condition { halt 422 unless send("#{type}_valid?") }
  end
end

helpers do
  def word_valid?
    WordJob.valid?(params[:word])
  end
end

get '/w', auth: :user do
  content_type 'application/json'

  job_id = Thread.current[:request_id] # X-Request-Id

  WordJob.all(session[:user_id], job_id).to_json
end

post '/w/:word', auth: :user, validate: :word do
  request.body.rewind
  payload = request.body.read
  job_id = Thread.current[:request_id] # X-Request-Id

  content_type 'application/json'
  status 201

  WordJob.insert_or_update(session[:user_id], params[:word], payload,
                           job_id).to_json
end

put '/w/:word/learned', auth: :user, validate: :word do
  status 204
  body nil

  job_id = Thread.current[:request_id] # X-Request-Id

  WordJob.learned(session[:user_id], params[:word], job_id)
end

delete '/w/:word', auth: :user, validate: :word do
  status 204
  body nil

  job_id = Thread.current[:request_id] # X-Request-Id

  WordJob.delete(session[:user_id], params[:word], job_id)
end

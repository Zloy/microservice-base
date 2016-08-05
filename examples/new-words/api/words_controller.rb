register do
  def validate(type)
    condition { halt 422 unless send("#{type}_valid?") }
  end
end

helpers do
  def word_valid?
    Word.valid?(params[:word])
  end
end

get '/w', auth: :user do
  content_type 'application/json'

  job_id = Thread.current[:request_id] # X-Request-Id

  Word.all(session[:user_id], job_id).to_json
end

post '/w/:word', auth: :user, validate: :word do
  request.body.rewind
  payload = request.body.read

  content_type 'application/json'
  status 201

  Word.insert_or_update(session[:user_id], params[:word], payload).to_json
end

put '/w/:word/learned', auth: :user, validate: :word do
  status 204
  body nil

  Word.learned(session[:user_id], params[:word])
end

delete '/w/:word', auth: :user, validate: :word do
  status 204
  body nil

  Word.delete(session[:user_id], params[:word])
end

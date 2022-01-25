get '/' do
  File.read(File.join('app/views', 'index.html'))
end
get '/1' do
  File.read(File.join('app/views', 'in.html'))
end
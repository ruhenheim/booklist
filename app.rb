require 'sinatra'
require 'mysql2'

enable :method_override
set :views, Proc.new { File.join(root, "templates") }
# p settings.views
# p settings.server
# p ENV['APP_ENV']

delete '/books/:id' do
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'booklist', encoding: 'utf8')

  statement = client.prepare('DELETE FROM books WHERE id=?')
  statement.execute(params[:id])

  redirect "/"
end

post '/books/:id' do
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'booklist', encoding: 'utf8')

  statement = client.prepare('UPDATE books SET book_title=? WHERE id=?')
  statement.execute(params[:books][:title], params[:id])

  redirect "/"
end

get '/' do
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'booklist', encoding: 'utf8')
  # write a procedure using MYSQL.
  @records = client.query("SELECT * FROM books ORDER BY created_at DESC")

  erb :booklist

end

post '/' do
  client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'booklist', encoding: 'utf8')

  #画面で入力した書籍タイトルの保存
  book_title = params['book_title']
  statement = client.prepare('INSERT INTO books (book_title) VALUES(?)')
  statement.execute(book_title)

  @records = client.query("SELECT * FROM books ORDER BY created_at DESC")
  erb :booklist
end

# Example Userという名前とメールアドレスを持つ1人のユーザと、
# それらしい名前とメールアドレスを持つ99人のユーザーを作成

# create!は基本的にcreateメソッドと同じものですが、
# ユーザーが無効な場合にfalseを返すのではなく例外を発生させる
# admin: trueで管理者ユーザを作成
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# orderメソッドを経由することで、明示的に最初の(IDが小さい順に)6人を呼び出す
users = User.order(:created_at).take(6)
# 上記の6人に50個分のマイクロポストを追加する
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
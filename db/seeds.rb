# Example Userという名前とメールアドレスを持つ1人のユーザと、
# それらしい名前とメールアドレスを持つ99人のユーザーを作成

# create!は基本的にcreateメソッドと同じものですが、
# ユーザーが無効な場合にfalseを返すのではなく例外を発生させる
# admin: trueで管理者ユーザを作成
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
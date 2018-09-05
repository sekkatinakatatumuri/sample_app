### 4.3.3-3

# person1 = {:first => "斎藤", :last => "飛鳥"}
# person2 = {:first => "渡邉", :last => "理佐"}
# person3 = {:first => "西野", :last => "七瀬"}

# params = {}
# params[:father] = person1
# params[:mother] = person2
# params[:child] = person3

# p params[:father][:first] == person1[:first]

### 4.3.3-4

# user = {
#   name: "深川麻衣", 
#   email: "maimaimainiti@gmail.com", 
#   password_digest: "4646464646464646"
# }

### 4.3.3-5

# { "a" => 100, "b" => 200 }.merge({ "b" => 300 })

### 4.4.1-1 (意味不明)

# a = 1..10

### 4.4.1-2

# b = Range.new(1, 10)

### 4.4.1-3

# p a == b

### 4.4.2-1

# p Range.class.superclass.superclass.superclass

# class Word < String
#   # 文字列が回文であればtrueを返す
#   def palindrome?
#     self == reverse
#   end
# end

# s = Word.new("なかだかな")
# p s.palindrome?

###4.4.3-1

# class String
#   # 文字列が回文であればtrueを返す
#   def palindrome?
#     self == reverse
#   end
# end

# p "racecar".palindrome?
# p "onomatopoeia".palindrome?

###4.4.3-2 / 3-3

# class String
#   # 文字列が回文であればtrueを返す
#   def shuffle
#     # self.split("").shuffle.join
#     split("").shuffle.join # 3-3
#   end
# end

# p "foobar".shuffle


#### 4.4.5

# class User
#   attr_accessor :first_name, :last_name, :email

#   ### 4.4.5-1
#   def initialize(attributes = {})
#     @first_name  = attributes[:first_name]
#     @last_name  = attributes[:last_name]
#     @email = attributes[:email]
#   end

#   def formatted_email
#     "#{full_name} <#{@email}>"
#   end
  
#   def full_name
#     "#{@first_name} #{@last_name}"
#   end
  
#   ### 4.4.5-2
#   def alphabetical_name
#     "#{@last_name}, #{@first_name}"
#   end
# end

### 4.4.5-3
# user.alphabetical_name.split(", ").reverse == user.full_name.split
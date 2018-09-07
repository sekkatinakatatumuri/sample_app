require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # 各テストが走る直前に実行されるメソッド
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  # 有効なUserかどうかをテスト
  test "should be valid" do
    assert @user.valid?
  end

  # name属性の存在性の検証
  test "name should be present" do
    @user.name = "     "
    # Userオブジェクトが有効でなくなったことを確認
    assert_not @user.valid?
  end

  # email属性の存在性の検証
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  # name属性の長さの検証(51文字)
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # email属性の長さの検証(255文字)
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # email属性のフォーマットの検証(valid)
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # どのメールアドレスでテストが失敗したのかを特定できる
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # email属性のフォーマットの検証(Invalidity)
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # email属性の一意性の検証
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # email属性を小文字にする検証
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end

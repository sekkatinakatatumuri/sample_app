require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # 各テストが走る直前に実行されるメソッド
  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
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

  # password属性が空でない検証
  test "password should be present (nonblank)" do
    # 多重代入 (Multiple Assignment)
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # password属性が長さが6文字以上の検証
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # 記憶ダイジェストを持たないユーザーを用意し検証
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  # ユーザーを削除したとき、関連するマイクロポストが破棄されるかテスト
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # フォロー・アンフォロー関連のメソッドのテスト
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    # following?メソッドでarcherをまだフォローしていないことを確認
    assert_not michael.following?(archer)
    # followメソッドを使ってarcherをフォロー
    michael.follow(archer)
    # archerをフォロー中になったことを確認
    assert michael.following?(archer)
    # archerのフォロワーにmichaelが含まれているか確認
    assert archer.followers.include?(michael)
    # unfollowメソッドでarcherをフォロー解除
    michael.unfollow(archer)
    # archerをフォロー解除できたことを確認
    assert_not michael.following?(archer)
  end

  # 現在のユーザーによってフォローされているユーザーに対応する
  # ユーザーidを持つマイクロポストを取り出し、
  # 同時に現在のユーザー自身のマイクロポストも一緒に取り出す。

  # ステータスフィードのテスト
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end

require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    # fixtureのサンプルユーザーと紐付けた新しいマイクロポストを作成
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # 作成したマイクロポストが有効かどうかをテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idの存在性のバリデーションに対するテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # contentの存在性のバリデーションに対するテスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # contenの文字数が141文字を超えた場合のテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end

require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    # fixtureのサンプルユーザーと紐付けた新しいマイクロポストを作成
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
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
end

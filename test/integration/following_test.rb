require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  # フォロー画面のテスト
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    # 正しい数かどうかを確認
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      # 正しいURLかどうかを確認
      assert_select "a[href=?]", user_path(user)
    end
  end

  # フォロワー画面のテスト
  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  # 標準版のフォローに対するテスト
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  # Ajax版のフォローに対するテスト
  test "should follow a user with Ajax" do
    # POSTリクエストを送信し、フォローしている数が1つ増えることを確認
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  # 標準版のアンフォローに対するテスト
  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  # Ajax版のアンフォローに対するテスト
  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    # DELETEリクエストを送信し、フォローしている数が1つ減ることを確認
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
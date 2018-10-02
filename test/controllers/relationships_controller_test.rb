require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # RelationshipsコントローラーのCreateアクションのテスト
  test "create should require logged-in user" do
    # Relationshipのカウントが変わっていないことを確認
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    # ログインページにリダイレクトされることを確認
    assert_redirected_to login_url
  end

  # Relationshipsコントローラーのdestroyアクションのテスト
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
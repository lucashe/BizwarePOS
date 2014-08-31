require 'test_helper'

class StoreBranchesControllerTest < ActionController::TestCase
  setup do
    @store_branch = store_branches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:store_branches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store_branch" do
    assert_difference('StoreBranch.count') do
      post :create, store_branch: {  }
    end

    assert_redirected_to store_branch_path(assigns(:store_branch))
  end

  test "should show store_branch" do
    get :show, id: @store_branch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @store_branch
    assert_response :success
  end

  test "should update store_branch" do
    patch :update, id: @store_branch, store_branch: {  }
    assert_redirected_to store_branch_path(assigns(:store_branch))
  end

  test "should destroy store_branch" do
    assert_difference('StoreBranch.count', -1) do
      delete :destroy, id: @store_branch
    end

    assert_redirected_to store_branches_path
  end
end

require 'test_helper'

class CelebrationsControllerTest < ActionController::TestCase
  setup do
    @celebration = celebrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:celebrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create celebration" do
    assert_difference('Celebration.count') do
      post :create, celebration: { celebrated_on: @celebration.celebrated_on, country: @celebration.country, message: @celebration.message, name: @celebration.name }
    end

    assert_redirected_to celebration_path(assigns(:celebration))
  end

  test "should show celebration" do
    get :show, id: @celebration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @celebration
    assert_response :success
  end

  test "should update celebration" do
    put :update, id: @celebration, celebration: { celebrated_on: @celebration.celebrated_on, country: @celebration.country, message: @celebration.message, name: @celebration.name }
    assert_redirected_to celebration_path(assigns(:celebration))
  end

  test "should destroy celebration" do
    assert_difference('Celebration.count', -1) do
      delete :destroy, id: @celebration
    end

    assert_redirected_to celebrations_path
  end
end

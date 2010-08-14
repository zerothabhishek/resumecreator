require 'test_helper'

class RhelpsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rhelps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rhelp" do
    assert_difference('Rhelp.count') do
      post :create, :rhelp => { }
    end

    assert_redirected_to rhelp_path(assigns(:rhelp))
  end

  test "should show rhelp" do
    get :show, :id => rhelps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rhelps(:one).to_param
    assert_response :success
  end

  test "should update rhelp" do
    put :update, :id => rhelps(:one).to_param, :rhelp => { }
    assert_redirected_to rhelp_path(assigns(:rhelp))
  end

  test "should destroy rhelp" do
    assert_difference('Rhelp.count', -1) do
      delete :destroy, :id => rhelps(:one).to_param
    end

    assert_redirected_to rhelps_path
  end
end

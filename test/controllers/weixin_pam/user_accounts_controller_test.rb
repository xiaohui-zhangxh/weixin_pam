require 'test_helper'

module WeixinPam
  class UserAccountsControllerTest < ActionController::TestCase
    setup do
      @user_account = weixin_pam_user_accounts(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:user_accounts)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create user_account" do
      assert_difference('UserAccount.count') do
        post :create, user_account: { headshot: @user_account.headshot, nickname: @user_account.nickname, public_account_id: @user_account.public_account_id, subscribed: @user_account.subscribed, uid: @user_account.uid }
      end

      assert_redirected_to user_account_path(assigns(:user_account))
    end

    test "should show user_account" do
      get :show, id: @user_account
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @user_account
      assert_response :success
    end

    test "should update user_account" do
      patch :update, id: @user_account, user_account: { headshot: @user_account.headshot, nickname: @user_account.nickname, public_account_id: @user_account.public_account_id, subscribed: @user_account.subscribed, uid: @user_account.uid }
      assert_redirected_to user_account_path(assigns(:user_account))
    end

    test "should destroy user_account" do
      assert_difference('UserAccount.count', -1) do
        delete :destroy, id: @user_account
      end

      assert_redirected_to user_accounts_path
    end
  end
end

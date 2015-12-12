require 'test_helper'

module WeixinPam
  class PublicAccountsControllerTest < ActionController::TestCase
    setup do
      @public_account = weixin_pam_public_accounts(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:public_accounts)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create public_account" do
      assert_difference('PublicAccount.count') do
        post :create, public_account: { api_token: @public_account.api_token, api_url: @public_account.api_url, app_id: @public_account.app_id, app_secret: @public_account.app_secret, enabled: @public_account.enabled, name: @public_account.name }
      end

      assert_redirected_to public_account_path(assigns(:public_account))
    end

    test "should show public_account" do
      get :show, id: @public_account
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @public_account
      assert_response :success
    end

    test "should update public_account" do
      patch :update, id: @public_account, public_account: { api_token: @public_account.api_token, api_url: @public_account.api_url, app_id: @public_account.app_id, app_secret: @public_account.app_secret, enabled: @public_account.enabled, name: @public_account.name }
      assert_redirected_to public_account_path(assigns(:public_account))
    end

    test "should destroy public_account" do
      assert_difference('PublicAccount.count', -1) do
        delete :destroy, id: @public_account
      end

      assert_redirected_to public_accounts_path
    end
  end
end

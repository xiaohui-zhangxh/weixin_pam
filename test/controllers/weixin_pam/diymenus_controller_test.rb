require 'test_helper'

module WeixinPam
  class DiymenusControllerTest < ActionController::TestCase
    setup do
      @diymenu = weixin_pam_diymenus(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:diymenus)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create diymenu" do
      assert_difference('Diymenu.count') do
        post :create, diymenu: { is_show: @diymenu.is_show, key: @diymenu.key, name: @diymenu.name, parent_id: @diymenu.parent_id, public_account_id: @diymenu.public_account_id, sort: @diymenu.sort, url: @diymenu.url }
      end

      assert_redirected_to diymenu_path(assigns(:diymenu))
    end

    test "should show diymenu" do
      get :show, id: @diymenu
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @diymenu
      assert_response :success
    end

    test "should update diymenu" do
      patch :update, id: @diymenu, diymenu: { is_show: @diymenu.is_show, key: @diymenu.key, name: @diymenu.name, parent_id: @diymenu.parent_id, public_account_id: @diymenu.public_account_id, sort: @diymenu.sort, url: @diymenu.url }
      assert_redirected_to diymenu_path(assigns(:diymenu))
    end

    test "should destroy diymenu" do
      assert_difference('Diymenu.count', -1) do
        delete :destroy, id: @diymenu
      end

      assert_redirected_to diymenus_path
    end
  end
end

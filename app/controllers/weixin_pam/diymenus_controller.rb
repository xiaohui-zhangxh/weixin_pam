require_dependency "weixin_pam/application_controller"

module WeixinPam
  class DiymenusController < ApplicationController
    before_action :set_public_account
    before_action :set_diymenu, only: [:show, :edit, :update, :destroy]

    # GET /diymenus
    def index
      @page_name = 'diymenus_index'
      @diymenus = @public_account.diymenus
    end

    # GET /diymenus/new
    def new
      @diymenu = @public_account.diymenus.new
    end

    # GET /diymenus/1/edit
    def edit
    end

    # POST /diymenus
    def create
      @diymenu = @public_account.diymenus.new(diymenu_params)

      if @diymenu.save
        redirect_to public_account_diymenus_path(@public_account), notice: '菜单创建成功.'
      else
        render :new
      end
    end

    # PATCH/PUT /diymenus/1
    def update
      if @diymenu.update(diymenu_params)
        flash[:notice] = '修改成功.'
      end
      render :edit
    end

    # DELETE /diymenus/1
    def destroy
      @diymenu.destroy
      redirect_to public_account_diymenus_path(@public_account), notice: 'Diymenu was successfully destroyed.'
    end

    def sort
      state = JSON.parse(params[:state])
      enabled_menus, disabled_menus = state

      save_sorted_menus enabled_menus, true
      save_sorted_menus disabled_menus, false
      render json: { action: :sort }
    end

    def upload
      result = @public_account.upload_menu
      render json: {
        action: :upload,
        ok: result.ok?,
        msg: result.cn_msg
      }
    end

    private

      def save_sorted_menus(state, enabled)
        Array(state).each_with_index do |parent_menu, i|
          parent_id = parent_menu['id']
          @public_account.diymenus.where(id: parent_id).update_all(parent_id: nil, is_show: enabled, sort: i)
          Array(parent_menu['children']).flatten.each_with_index do |sub_menu, j|
            @public_account.diymenus.where(id: sub_menu['id']).update_all(parent_id: parent_id, is_show: enabled, sort: j)
          end
        end
      end

      def set_public_account
        @public_account = PublicAccount.find(params[:public_account_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_diymenu
        @diymenu = @public_account.diymenus.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def diymenu_params
        params.require(:diymenu).permit(:parent_id, :name, :key, :url, :is_show, :sort)
      end
  end
end

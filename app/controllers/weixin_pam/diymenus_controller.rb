require_dependency "weixin_pam/application_controller"

module WeixinPam
  class DiymenusController < ApplicationController
    before_action :set_public_account
    before_action :set_diymenu, only: [:show, :edit, :update, :destroy]

    # GET /diymenus
    def index
      @diymenus = @public_account.diymenus
    end

    # GET /diymenus/1
    def show
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
        redirect_to [@public_account, @diymenu], notice: 'Diymenu was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /diymenus/1
    def update
      if @diymenu.update(diymenu_params)
        redirect_to @diymenu, notice: 'Diymenu was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /diymenus/1
    def destroy
      @diymenu.destroy
      redirect_to diymenus_url, notice: 'Diymenu was successfully destroyed.'
    end

    private
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

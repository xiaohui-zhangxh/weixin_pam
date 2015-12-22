require_dependency "weixin_pam/application_controller"

module WeixinPam
  class PublicAccountsController < ApplicationController
    before_action :set_public_account, only: [:show, :edit, :update, :destroy]

    # GET /public_accounts
    def index
      @public_accounts = PublicAccount.all
    end

    # GET /public_accounts/1
    def show
    end

    # GET /public_accounts/new
    def new
      @public_account = PublicAccount.new
    end

    # GET /public_accounts/1/edit
    def edit
    end

    # POST /public_accounts
    def create
      @public_account = PublicAccount.new(public_account_params)

      if @public_account.save
        redirect_to @public_account, notice: '公众号创建成功.'
      else
        render :new
      end
    end

    # PATCH/PUT /public_accounts/1
    def update
      if @public_account.update(public_account_params)
        redirect_to @public_account, notice: '公众号修改成功.'
      else
        render :edit
      end
    end

    # DELETE /public_accounts/1
    def destroy
      @public_account.destroy
      redirect_to public_accounts_url, notice: '成功删除公众号.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_public_account
        @public_account = PublicAccount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def public_account_params
        params.require(:public_account).permit(:name, :app_id, :app_secret, :api_url, :api_token, :enabled, :host, :reply_class)
      end
  end
end

require_dependency "weixin_pam/application_controller"

module WeixinPam
  class UserAccountsController < ApplicationController
    before_action :set_public_account
    before_action :set_user_account, only: [:show, :edit, :update, :destroy]

    # GET /user_accounts
    def index
      @page_name = 'user_accounts_index'
      @user_accounts = @public_account.user_accounts
    end

    # GET /user_accounts/1
    def show
    end

    # GET /user_accounts/new
    def new
      @user_account = @public_account.user_accounts.new
    end

    # GET /user_accounts/1/edit
    def edit
    end

    # POST /user_accounts
    def create
      @user_account = @public_account.user_accounts.new(user_account_params)

      if @user_account.save
        redirect_to @user_account, notice: 'User account was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /user_accounts/1
    def update
      if @user_account.update(user_account_params)
        redirect_to @user_account, notice: 'User account was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /user_accounts/1
    def destroy
      @user_account.destroy
      redirect_to user_accounts_url, notice: 'User account was successfully destroyed.'
    end

    def sync
      UserAccount.sync_from_server(@public_account)
      render json: { action: 'sync_users', success: true }
    rescue
      render json: { action: 'sync_users', success: false, error: $!.message }
    end

    private

      def set_public_account
        @public_account = PublicAccount.find(params[:public_account_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_user_account
        @user_account = @public_account.user_accounts.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_account_params
        params.require(:user_account).permit(:public_account_id, :uid, :nickname, :headshot, :subscribed)
      end
  end
end

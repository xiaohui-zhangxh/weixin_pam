require_dependency "weixin_pam/application_controller"

module WeixinPam
  class UserAccountsController < ApplicationController
    before_action :set_user_account, only: [:show, :edit, :update, :destroy]

    # GET /user_accounts
    def index
      @user_accounts = UserAccount.all
    end

    # GET /user_accounts/1
    def show
    end

    # GET /user_accounts/new
    def new
      @user_account = UserAccount.new
    end

    # GET /user_accounts/1/edit
    def edit
    end

    # POST /user_accounts
    def create
      @user_account = UserAccount.new(user_account_params)

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

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user_account
        @user_account = UserAccount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_account_params
        params.require(:user_account).permit(:public_account_id, :uid, :nickname, :headshot, :subscribed)
      end
  end
end

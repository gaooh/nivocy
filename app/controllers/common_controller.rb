class CommonController < ApplicationController
  before_filter :signin_filter
  
  # ユーザ一覧を部署で切り替える
  def ajax_update_users
    @users = Division.find(params[:division_id]).users
    @form_id = params[:form_id]
  end
end

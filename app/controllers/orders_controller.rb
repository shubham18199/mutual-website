class OrdersController < ApplicationController
  def index
    @user = current_user
    @orders = @user.orders.includes(:product).order(created_at: :desc)
  end
end

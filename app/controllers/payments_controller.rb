# app/controllers/payments_controller.rb

class PaymentsController < ApplicationController
  def new
  end

  def create
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])

    amount = params[:amount].to_i * 100  # Convert to paise (Indian currency)

    order = Razorpay::Order.create(
      amount: amount,
      currency: 'INR',
      receipt: 'TEST',
      payment_capture: 1
    )

    # Redirect to the Razorpay checkout page
    redirect_to order.short_url
  end
end

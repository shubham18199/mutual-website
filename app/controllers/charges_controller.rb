class ChargesController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
  end  
  def new
  end
  def success
    session_id = params[:session_id]
  @session = Stripe::Checkout::Session.retrieve(session_id)
  puts "Session Data: #{@session.customer_details.name}"
  
 

    product_ids = @session.metadata['product_id'].split(', ')

    # Create order records for each product
    product_ids.each do |product_id|
      Order.create(
        user_id: current_user.id,
        product_id: product_id
      )
    end
  
  end  
  
  def create
    product = Product.find(params[:id])
    img = params[:image]
    product_image_url = url_for(product.image)
    puts "Image url: #{product_image_url}"

    price_in_cents = (product.price * 100).to_i

    customer = Stripe::Customer.create(
      email: current_user.email,
      # Add other customer information as needed
    )
    @session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
      line_items: [{
        price_data: {
          currency: 'INR',
          product_data: {
            name: product.name,
            images: [ product_image_url]
          },
          unit_amount: price_in_cents ,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: "http://localhost:3000/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url,
      metadata: {product_id: product.id},
      billing_address_collection: 'required', # Request billing address
      shipping_address_collection: {
        allowed_countries: ['IN', 'CA'], # Specify the allowed countries
      },
      phone_number_collection: { enabled: true}
    })
    redirect_to charges_path(session_id: @session.id)
    
  end

  

end

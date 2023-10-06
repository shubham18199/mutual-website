class CartItemsController < ApplicationController
    before_action :authenticate_user!
    def index
        @cart_item = current_user.cart_items.all
        @cart = calculate_total()
    end

    def create
        @cart_item = current_user.cart_items.build(product_id: params[:product_id])
        @cart_item.quantity = 1
        puts "quantity: #{@cart_item.quantity}"
        @cart_item.save
        redirect_to cart_items_path, notice: 'Item added to cart'
    end

    def destroy
        @cart_item = current_user.cart_items.find(params[:id])
        @cart_item.destroy
        redirect_to cart_items_path, notice: 'Item removed from cart'
    end
    def add_item
      cart_item = current_user.cart_items.find_or_initialize_by(product_id: params[:product_id])
      cart_item.quantity += 1
      cart_item.save
      redirect_to cart_items_path
    end
  
    def subtract_item
      cart_item = current_user.cart_items.find_by(product_id: params[:product_id])
      if cart_item && cart_item.quantity > 1
        cart_item.quantity -= 1
        cart_item.save
      end
      redirect_to cart_items_path
    end
    def checkout
        line_items = []
        current_user.cart_items.each do |cart_item|
          puts "product_id: #{cart_item.product.id}"
            image_url = url_for(cart_item.product.image)
            # url = JSON.image_url rails_blob_url(cart_item.product.image)


            line_items << {
              price_data: {
                currency: 'INR',
                product_data: {
                  name:  cart_item.product.name ,
                  
                  images: [image_url]
                },
                unit_amount: ( cart_item.product.price  * 100).to_i,
              },
              quantity: cart_item.quantity,
            }
          end
        
          @session = Stripe::Checkout::Session.create({
            customer_email: current_user.email,
            line_items: line_items,
            mode: 'payment',
            success_url: "http://localhost:3000/success?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: root_url,
            billing_address_collection: 'required', # Request billing address
            shipping_address_collection: {
              allowed_countries: ['IN', 'CA'], # Specify the allowed countries
            },
            phone_number_collection: { enabled: true},
            metadata: {
              # Add your product data here
              products: line_items.map { |item| item[:price_data][:product_data][:name] }.join(', '),
              product_id: current_user.cart_items.map { |cart_item| cart_item.product.id }.join(', ')
            }
          })
      
          redirect_to charges_path(session_id: @session.id)
    end


    private

    def calculate_total 
        current_user.cart_items.sum { |item| item.product.price * item.quantity }
    end
end

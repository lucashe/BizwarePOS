class PaymentsController < ApplicationController
  
  def make_payment
    @sale = Sale.find(params[:sale_id])
    @sale.is_final = true
    @sale.save

    payment = Payment.create(:payment_type => params[:payment_type], :amount => params[:payment_amount], :sale_id => params[:sale_id])

    if not @sale.customer.nil?
      @customer = @sale.customer
    @customer.rewards = @customer.rewards - @sale.rewards_used + @sale.rewards_earned
    @customer.save
    end

    respond_to do |format|
      format.html { redirect_to sale_path(@sale), notice: 'Payment was done.' }
      format.js
    end
  end

  private

  # def payment_params
  # params.require(:payment).permit(:payment_type, :amount, :sale_id)
  # end
end

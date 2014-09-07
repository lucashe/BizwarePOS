class PaymentsController < ApplicationController
  def make_payment
    @sale = Sale.find(params[:sale_id])
    payment = Payment.create(:payment_type => params[:payment_type], :amount => params[:payment_amount], :sale_id => params[:sale_id])

    respond_to do |format|
      format.html { redirect_to edit_sale_path(@sale), notice: 'Payment was done.' }
      format.js
    end
  end

  private

# def payment_params
# params.require(:payment).permit(:payment_type, :amount, :sale_id)
# end
end

class ChargesController < ApplicationController

	def charge_params
      params.require(:charge).permit(:customer, :amount, :description, :currency, :user_id, :expert_id, :pay, :stripetoken)
    end
end

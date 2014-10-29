class NctuCceController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
    
  def new
    @item = Item.new
    @item.module=params[:module]  
  end
  
  def create
    @item = Item.new(item_params)  
    @item.user = current_user 
    if @item.save
      redirect_to controller: :items, action: :createCompletion, id: @item.id
    else
      render :new
    end    
  end  
  
  def apply
    
  end
  
  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:module, :verification_code, :title, :description, :no_of_user, :price,
                                   :start_at, :end_at, :payment_strat_at, :payment_end_at)
    end  
end

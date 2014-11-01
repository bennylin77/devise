class NctuCceController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
    
  def new
    @group = Group.new( module: params[:module])
    @group.items.build(verification_code: params[:verification_code])    
  end
  
  def create
    @group = Group.new(group_params) 
    @group.items.first.user = current_user 
    if @group.save
      redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id
    else
      render :new
    end    
  end  
  
  def first
    @user=current_user
    
  end
  
  def second
    
  end
  
  def third
    
  end  
  
  
  private
    def set_item
      @item = Item.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:module, :title, :description, items_attributes: [ :verification_code, :no_of_user, :price,
                                    :start_at, :end_at, :payment_strat_at, :payment_end_at])
    end  
end

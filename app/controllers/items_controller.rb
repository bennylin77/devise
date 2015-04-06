class ItemsController < ApplicationController

  before_filter :authenticate_user!, only: [:indexManagement, :new, :create, :progress]   
  
  before_action :set_item, only: [:show, :edit, :update, :destroy, :createCompletion]
  before_action :set_progress, only: [:progressStatus]
  def index
    @items = Item.all.paginate(per_page: 30, page: params[:page])
  end
  
  def indexManagement
    @items = current_user.items
  end

  def show
  end

  def new
  end

  def create
    # check identified code and redirect to right module
    case params[:module]
    when GLOBAL_VAR['NCTU_CCE'].to_s
      redirect_to controller: :nctu_cce, action: :new, module: params[:module]
    when GLOBAL_VAR['NCTU_CCE_credit'].to_s
      redirect_to controller: :nctu_cce_credit, action: :new, module: params[:module]
    when GLOBAL_VAR['NCTU_CCE_camp'].to_s
      redirect_to controller: :nctu_cce_camp, action: :new, module: params[:module]
    else
      flash[:error]='請選擇模組'
      redirect_to new_item_path
    end
  end
  
  def createCompletion
    flash[:success]='成功建立 '+@item.group.title
  end  
=begin

  def edit
  end  

  def update
    @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end
=end  
  def progress
    @progresses = current_user.progresses.order('stage DESC')
  end
  
  def progressStatus
    
  	if @data and  @data.user == current_user
  		
  	else
  		flash[:error] = "Action Denied"
  		redirect_to "/items/progress"
  	end
  end

  private
  
    def set_item
      @item = Item.find(params[:id])
    end
    
    def set_progress
      @progress = Item.find(params[:id])      
    end

    def item_params
      params.require(:item).permit(:module)
    end
end

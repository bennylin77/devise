class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :createCompletion]

  def index
    @items = Item.all.paginate(per_page: 30, page: params[:page])
  end
  
  def indexManagement
    
  end

  def show

  end

  def new
    @item = Item.new

  end

  def edit
  end

  def create
    # check identified code and redirect to right module
    @item = Item.new(item_params)
    case @item.module
    when GLOBAL_VAR['CCE_NCTU']
      redirect_to controller: :nctu_cce, action: :new, module: @item.module
    when 2

    when 3

    else
      flash[:error]='請選擇模組'
      redirect_to new_item_path
    end
  end
  
  def createCompletion
    flash[:success]='成功建立 '+@item.title
  end  

  def update
    @item.update(item_params)
    respond_with(@item)
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:module)
    end
end

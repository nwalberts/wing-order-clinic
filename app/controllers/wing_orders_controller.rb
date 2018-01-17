class WingOrdersController < ApplicationController
  def index
    @wing_orders = WingOrder.all
  end

  def new
    @wing_order = WingOrder.new
    @state_collection = WingOrder::STATES
    @quantity_collection = WingOrder::QUANTITIES
    @flavor_collection = Flavor.all

    render "wing_orders/new"
  end

  def create
    @wing_order = WingOrder.new(wing_order_params)
    @wing_order.flavors = Flavor.where(id: params[:wing_order][:flavor_ids])
    if @wing_order.save
      flash[:notice] = "Wing order created!"
      redirect_to wing_orders_path
    else
      flash[:alert] = "Wing order not created"
      @state_collection = WingOrder::STATES
      @quantity_collection = WingOrder::QUANTITIES
      @flavor_collection = Flavor.all
      render :new
    end
  end

  def edit
    @wing_order = WingOrder.find(params[:id])
    @state_collection = WingOrder::STATES
    @quantity_collection = WingOrder::QUANTITIES
    @flavor_collection = Flavor.all
  end

  def update
    @wing_order = WingOrder.find(params[:id])
    @wing_order.flavors = Flavor.where(id: params[:wing_order][:flavor_ids])
    if @wing_order.update_attributes(wing_order_params)
      flash[:notice] = "YAYYY YOU DID IT I AM SO SO PROUD"
      redirect_to wing_orders_path
    else
      flash[:error] = @wing_order.errors.full_messages.join(", ")
      @state_collection = WingOrder::STATES
      @quantity_collection = WingOrder::QUANTITIES
      @flavor_collection = Flavor.all
      render :edit
    end
  end

  def destroy
    @wing_order = WingOrder.find(params[:id])
    @wing_order.destroy

    redirect_to wing_orders_path
  end

  private

  def wing_order_params
    params.require(:wing_order).permit(
      :customer_name,
      :city,
      :state,
      :quantity,
      :ranch_dressing
    )
  end
end

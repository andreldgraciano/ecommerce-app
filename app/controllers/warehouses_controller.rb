class WarehousesController < ApplicationController

  def index
    @warehouses = Warehouse.all
  end

  def show
    id = params[:id]
    response = Faraday.get("http://localhost:4000/api/v1/warehouses/#{id}")
    if response.status == 200
      @warehouse = JSON.parse(response.body)
    else
      redirect_to root_path, notice: 'Não foi possível carregar o galpão'
    end
  end
end

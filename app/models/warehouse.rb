class Warehouse
  attr_accessor :id, :name, :code, :city, :area, :address, :zip, :description

  def initialize(id:, name:, code:, city:, area:, address:, zip:, description:)
    @id = id
    @name = name
    @code = code
    @city = city
    @area = area
    @address = address
    @zip = zip
    @description = description
  end

  # isto cria um metodo de classe, nao para uma instancia.
  def self.all
    warehouses = []
    response = Faraday.get('http://localhost:4000/api/v1/warehouses')

    if response.status == 200
      data_api = JSON.parse(response.body)

      data_api.each do |data|
        warehouses << Warehouse.new(
          id: data["id"],
          name: data["name"],
          code: data["code"],
          city: data["city"],
          area: data["area"],
          address: data["address"],
          zip: data["zip"],
          description: data["description"]
        )
      end
    end
    
    warehouses
  end

end

require 'rails_helper'

describe Warehouse do
  context '.all' do
    it 'deve retornar todos os galpões' do
      json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

      result = Warehouse.all

      expect(result.length).to eq(2)
      expect(result[0].id).to eq(1)
      expect(result[0].name).to eq('Rodoviaria RIO')
      expect(result[0].code).to eq('GRJ')
      expect(result[0].city).to eq('Rio de Janeiro')
      expect(result[0].area).to eq(123435)
      expect(result[0].address).to eq('Rua Sebastião Azeredo Campos, 123')
      expect(result[0].zip).to eq(35300390)
      expect(result[0].description).to eq('Galpao na rodoviaria do RJ')
      expect(result[1].id).to eq(2)
      expect(result[1].name).to eq('Aeroporto Sampa')
      expect(result[1].code).to eq('SPY')
      expect(result[1].city).to eq('Sao Paulo')
      expect(result[1].area).to eq(5412934)
      expect(result[1].address).to eq('Avenida Jardim, 32')
      expect(result[1].zip).to eq(25655260)
      expect(result[1].description).to eq('galpao de sao paulo')
    end

    it 'deve retornar vazio se a API está indisponível' do
      fake_response = double('daraday_response', status: 500, body: "{}")
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

      result = Warehouse.all

      expect(result).to eq([])
    end
  end
end

require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê galpões' do
    warehouses = []
    warehouses << Warehouse.new(
      id: 1,
      code: "GRJ",
      city: "Rio de Janeiro",
      area: 123435,
      name: "Rodoviaria RIO",
      address: "Rua Sebastião Azeredo Campos, 123",
      zip: 35300390,
      description: "Galpao na rodoviaria do RJ"
    )
    warehouses << Warehouse.new(
      id: 2,
      code: "SPY",
      city: "Sao Paulo",
      area: 5412934,
      name: "Aeroporto Sampa",
      address: "Avenida Jardim, 32",
      zip: 25655260,
      description: "galpao de sao paulo"
    )
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit(root_path)

    expect(page).to have_content('E-Commerce App')
    expect(page).to have_content('RIO')
    expect(page).to have_content('Rio de Janeiro')
  end

  it 'e não existem galpões' do
    warehouses = []
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit(root_path)

    expect(page).to have_content('Nenhum galpão encontrado')
  end

  it 'e vê detalhes de um galpão' do
    # baixando a index
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    # baixando o datails do galpão selecionado
    json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/2').and_return(fake_response)

    visit(root_path)
    click_on('Aeroporto Sampa')

    expect(page).to have_content('Galpão SPY - Aeroporto Sampa')
    expect(page).to have_content('Sao Paulo')
    expect(page).to have_content('Avenida Jardim, 32 - CEP 25655260')
    expect(page).to have_content('galpao de sao paulo')
  end

  it 'e não existem galpões' do
    fake_response = double('faraday_response', status: 200, body: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit(root_path)

    expect(page).to have_content('Nenhum galpão encontrado')
  end

  it 'e não é possível carregar detalhes de um galpão' do
    # baixando a index
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    # baixando o datails do galpão selecionado
    error_response = double('faraday_response', status: 500, body: "{}")
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/2').and_return(error_response)

    visit(root_path)
    click_on('Aeroporto Sampa')

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Não foi possível carregar o galpão')
  end
end

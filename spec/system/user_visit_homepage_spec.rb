require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê galpões' do
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit(root_path)

    expect(page).to have_content('E-Commerce App')
    expect(page).to have_content('RIO')
    expect(page).to have_content('Rio de Janeiro')
  end

  it 'e não existem galpões' do
    fake_response = double('faraday_response', status: 200, body: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit(root_path)

    expect(page).to have_content('Nenhum galpão encontrado')
  end
end

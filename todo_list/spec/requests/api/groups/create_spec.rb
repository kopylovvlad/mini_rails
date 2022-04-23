# frozen_string_literal: true

MiniRSpec.describe 'Api::Group' do
  describe "POST /api/groups" do
    before_each { post "/api/groups", params }

    context 'valid data' do
      let!(:params) { { title: 'Hello', description: 'World!' } }
      it 'creates item' do
        expect(response).to have_http_status(201)
        expect(json['title']).to eq('Hello')
        expect(json['description']).to eq('World!')
      end
    end

    context 'invalid data' do
      let!(:params) { { title: nil, description: nil } }

      it 'returns errors' do
        expect(response).to have_http_status(422)
        expect(json['errors']).to include('Title must be present')
      end
    end
  end
end

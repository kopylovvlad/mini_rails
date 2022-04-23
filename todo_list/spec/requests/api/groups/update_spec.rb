# frozen_string_literal: true

MiniRSpec.describe 'Api::Group' do
  describe "PATCH /api/groups/:id" do
    let!(:group) { create(:group) }

    before_each { patch "/api/groups/#{group.id}", params }

    context 'valid data' do
      let!(:params) { { title: 'Hello', description: 'World!' } }

      it 'creates item' do
        expect(response).to have_http_status(200)
        expect(json['title']).to eq('Hello')
        expect(json['description']).to eq('World!')
      end
    end

    context 'invalid ID' do
      let!(:group) { build(:group, id: '123123') }
      let!(:params) { { title: 'Hello' } }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'invalid data' do
      let!(:params) { { title: '12' } }

      it 'returns errors' do
        expect(response).to have_http_status(422)
        expect(json['errors']).to include('Title must be greater then 3')
      end
    end
  end
end

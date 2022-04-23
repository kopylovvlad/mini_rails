# frozen_string_literal: true

MiniRSpec.describe 'Api::Item' do
  describe "POST /api/groups/:group_id/items" do
    before_each { post "/api/groups/#{group.id}/items", params }
    let!(:group) { create(:group) }

    context 'valid data' do
      let!(:params) { { title: 'Hello World!'} }

      it 'creates item' do
        expect(response).to have_http_status(201)
        expect(json['title']).to eq('Hello World!')
        expect(json['done']).to eq(false)
      end
    end

    context 'invalid data' do
      let!(:params) { { title: '1' } }

      it 'returns errors' do
        expect(response).to have_http_status(422)
        expect(json['errors']).to include('Title must be greater then 3')
      end
    end
  end
end

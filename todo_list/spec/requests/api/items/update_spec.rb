# frozen_string_literal: true

MiniRSpec.describe 'Api::Item' do
  describe "PATCH /api/groups/:group_id/items/:id" do
    let!(:group) { create(:group) }
    let!(:item) { create(:item, group_id: group.id, done: false) }
    let!(:params) { { title: 'Hello', done: true } }

    before_each { patch "/api/groups/#{group.id}/items/#{item.id}", params }

    context 'valid data' do
      it 'creates item' do
        expect(response).to have_http_status(200)
        expect(json['title']).to eq('Hello')
        expect(json['done']).to eq(true)
      end
    end

    context 'invalid item ID' do
      let!(:item) { build(:item, id: '123') }

      it 'returns 404' do
        expect(response).to have_http_status(404)
        expect(json['data']).to eq([])
        expect(json['error']).to eq('not_found')
      end
    end

    context 'invalid group ID' do
      let!(:group) { build(:group, id: '123') }
      let!(:item) { create(:item) }

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

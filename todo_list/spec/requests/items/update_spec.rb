# frozen_string_literal: true

MiniRSpec.describe 'Items' do
  describe 'PATCH /groups/:group_id/items/:id' do
    before_each { patch "/groups/#{group.id}/items/#{item.id}", params }

    let!(:group) { create(:group) }
    let!(:item) { create(:item, group_id: group.id, done: false) }
    let!(:params) { { title: 'Hello World!', done: true } }

    it 'redirects' do
      expect(response).to have_http_status(303)
      expect(response.headers['Location']).to eq("/groups/#{group.id}/items")
    end

    it 'updates only :done attribute' do
      updated_item = group.items.first
      expect(updated_item.title).not_to eq('Hello World!')
      expect(updated_item.done).to eq(true)
    end

    context 'wrong item id' do
      let!(:item) { build(:item, id: '11') }

      it 'renders 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to include('Not found. 404')
      end
    end

    context 'wrong group id' do
      let!(:group) { build(:group, id: '11') }
      let!(:item) { build(:item, id: '11') }

      it 'renders 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to include('Not found. 404')
      end
    end
  end
end

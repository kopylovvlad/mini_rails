# frozen_string_literal: true

MiniRSpec.describe 'Items' do
  describe 'DELETE /groups/:group_id/items/:id' do
    before_each { delete "/groups/#{group.id}/items/#{item.id}" }

    let!(:group) { create(:group) }
    let!(:item) { create(:item, group_id: group.id) }

    it 'redirects' do
      expect(response).to have_http_status(303)
      expect(response.headers['Location']).to eq("/groups/#{group.id}/items")
    end

    it 'deletes the item' do
      expect(group.items.count).to eq(0)
    end

    context 'wrong item id' do
      let!(:item) { build(:item, id: '111') }

      it 'renders 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to include('Страница не найдена')
      end
    end

    context 'wrong group id' do
      let!(:group) { build(:group, id: '1') }
      let!(:item) { build(:item, id: '2') }

      it 'renders 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to include('Страница не найдена')
      end
    end
  end
end

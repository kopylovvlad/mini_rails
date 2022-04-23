# frozen_string_literal: true

MiniRSpec.describe 'Api::Item' do
  describe "Delete /api/groups/:group_id/items/:id" do
    let!(:group) { create(:group) }
    let!(:item) { create(:item, group_id: group.id) }
    let!(:another_item) { create(:item, group_id: group.id) }

    context 'valid data' do
      it 'deleted item' do
        delete "/api/groups/#{group.id}/items/#{item.id}"
        expect(response).to have_http_status(200)
        expect(group.items.count).to eq(1)
      end
    end

    context 'invalid item ID' do
      it 'returns 404' do
        delete "/api/groups/#{group.id}/items/111"
        expect(response).to have_http_status(404)
        expect(group.items.count).to eq(2)
      end
    end

    context 'invalid group ID' do
      it 'returns 404' do
        delete "/api/groups/111/items/#{item.id}"
        expect(response).to have_http_status(404)
        expect(group.items.count).to eq(2)
      end
    end
  end
end

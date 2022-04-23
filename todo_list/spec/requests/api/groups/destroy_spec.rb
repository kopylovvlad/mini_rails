# frozen_string_literal: true

MiniRSpec.describe 'Api::Group' do
  describe "DELETE /api/groups/:id" do
    let!(:group) { create(:group) }
    let!(:items) { create_list(:item, 3, group_id: group.id) }

    context 'valid data' do
      before_each { delete "/api/groups/#{group.id}" }

      it 'returns 200 OK' do
        expect(response).to have_http_status(200)
      end

      it 'deletes group' do
        expect(Group.all.count).to eq(0)
      end

      it 'deletes items' do
        expect(Item.all.count).to eq(0)
      end
    end

    context 'invalid ID' do
      it 'returns 404' do
        delete "/api/groups/1111"
        expect(response).to have_http_status(404)
        expect(Group.all.count).to eq(1)
        expect(Item.all.count).to eq(3)
      end
    end
  end
end

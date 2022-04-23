# frozen_string_literal: true

MiniRSpec.describe 'Api::Item' do
  describe "GET /api/groups/:group_id/items" do
    before_each { get "/api/groups/#{group.id}/items" }

    context 'no data' do
      let!(:group) { build(:group, id: '123') }

      it 'returns 404 error' do
        expect(response).to have_http_status(404)
        expect(json['data']).to eq([])
        expect(json['error']).to eq('not_found')
      end
    end

    context 'group without items' do
      let!(:group) { create(:group) }

      it { expect(response).to have_http_status(200) }

      it 'returns empty body' do
        expect(json).to eq([])
      end
    end

    context 'group with items' do
      let!(:group) { create(:group) }
      let!(:items) { create_list(:item, 2, group_id: group.id) }
      let!(:keys) do
        ['id', 'created_at', 'title','group_id', 'done']
      end

      it { expect(response).to have_http_status(200) }
      it 'returns items' do
        expect(json.size).to eq(2)
        expect(json[0].keys).to eq(keys)
      end
    end
  end
end

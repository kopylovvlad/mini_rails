# frozen_string_literal: true

MiniRSpec.describe 'Api::Item' do
  describe "GET /api/groups/:group_id/items/:id" do
    before_each { get "/api/groups/#{group.id}/items/#{item.id}" }

    context 'right data' do
      let!(:group) { create(:group) }
      let!(:item) { create(:item, group_id: group.id) }

      it { expect(response).to have_http_status(200) }
      it 'returns data' do
        expect(json.keys).to eq(['id', 'created_at', 'title','group_id', 'done'])
        expect(json['id']).to eq(item.id)
        expect(json['group_id']).to eq(group.id)
      end
    end

    context 'fake group id' do
      let!(:group) { build(:group, id: '123') }
      let!(:item) { create(:item) }

      it { expect(response).to have_http_status(404) }
      it do
        expect(json['data']).to eq([])
        expect(json['error']).to eq('not_found')
      end
    end

    context 'fake item id' do
      let!(:group) { create(:group) }
      let!(:item) { build(:item, id: '222', group_id: group.id) }

      it { expect(response).to have_http_status(404) }
      it do
        expect(json['data']).to eq([])
        expect(json['error']).to eq('not_found')
      end
    end
  end
end

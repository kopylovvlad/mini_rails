# frozen_string_literal: true

MiniRSpec.describe 'Api::Group' do
  describe "GET /api/groups" do
    context 'no data' do
      before_each { get "/api/groups" }

      it { expect(response).to have_http_status(200) }
      it 'returns empty body' do
        expect(json).to eq([])
      end
    end

    context 'with data' do
      before_each { create_list(:group, 2) }
      before_each { get "/api/groups" }

      it "returns two items" do
        expect(response).to have_http_status(200)
        expect(json.size).to eq(2)
      end
    end

    context 'attributes' do
      before_each { get "/api/groups" }
      let!(:group) { create(:group) }
      let!(:keys) do
        ["id", "title", "description", "full_title", "created_at", "active_count", "not_active_count", "items"]
      end

      it "returns all attributes" do
        expect(json[0].keys).to eq(keys)
        expect(json[0]['id']).to eq(group.id)
        expect(json[0]['items']).to eq([])
        expect(json[0]['active_count']).to eq(0)
        expect(json[0]['not_active_count']).to eq(0)
      end

      describe 'some attributes' do
        let!(:group) { create(:group) }
        let!(:active_items) { create_list(:item, 1, group_id: group.id) }
        let!(:not_active_items) { create_list(:item, 2, :done, group_id: group.id) }

        describe '#items' do
          it { expect(json[0]['items'].size).to eq(3) }
        end

        describe '#active_count' do
          it { expect(json[0]['active_count']).to eq(1) }
        end

        describe '#not_active_count' do
          it { expect(json[0]['not_active_count']).to eq(2) }
        end
      end
    end
  end
end

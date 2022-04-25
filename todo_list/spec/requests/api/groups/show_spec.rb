# frozen_string_literal: true

MiniRSpec.describe 'Api::Group' do
  describe "GET /api/groups/:id" do
    context 'no data' do
      before_each { get "/api/groups/123" }

      it 'returns 404' do
        expect(response).to have_http_status(404)
        expect(json['data']).to eq([])
        expect(json['error']).to eq("not_found")
      end
    end

    context 'has data' do
      let!(:groups) { create_list(:group, 2) }

      before_each { get "/api/groups/#{groups.first.id}" }

      it 'returns 200' do
        expect(response).to have_http_status(200)
        expect(json['id']).to eq(groups.first.id)
      end
    end

    context 'attributes' do
      let!(:group) { create(:group) }
      let!(:active_items) { create(:item, group_id: group.id) }
      let!(:not_active_items) { create_list(:item, 2, :done, group_id: group.id) }

      before_each { get "/api/groups/#{group.id}" }

      it 'renders full title' do
        full_title = "#{group.title}: #{group.description}"
        expect(json['full_title']).to eq(full_title)
      end

      it 'renders active count' do
        expect(json['active_count']).to eq(1)
      end

      it 'renders not active count' do
        expect(json['not_active_count']).to eq(2)
      end
    end
  end
end

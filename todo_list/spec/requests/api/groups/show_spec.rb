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
  end
end

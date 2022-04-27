# frozen_string_literal: true

MiniRSpec.describe 'Items' do
  describe 'POST /groups/:group_id/items' do
    before_each { post "/groups/#{group.id}/items", params }

    let!(:group) { create(:group) }
    let!(:params) { { title: 'Hello World!' } }

    it 'redirects to Item#index' do
      expect(response).to have_http_status(303)
      expect(response.headers['Location']).to eq("/groups/#{group.id}/items")
    end

    it 'creates new item' do
      expect(group.items.count).to eq(1)
      item = group.items.first
      expect(item.title).to eq('Hello World!')
      expect(item.done).to eq(false)
    end

    context 'invalid data' do
      let!(:params) { { title: '1' } }

      it { expect(response).to have_http_status(422) }

      it 'renders alert' do
        expect(response.body).to include('We are having troubles')
        expect(response.body).to include('Title must be greater then 3')
      end
    end

    context 'wront group id' do
      let!(:group) { build(:group, id: '123') }

      it { expect(response).to have_http_status(404) }

      it 'renders 404' do
        expect(response.body).to include('Not found. 404')
      end
    end
  end
end

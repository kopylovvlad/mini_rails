# frozen_string_literal: true

MiniRSpec.describe 'Items' do
  describe 'GET /groups/:group_id/items' do
    before_each { get "/groups/#{group.id}/items" }
    let!(:group) { create(:group) }

    context 'with data' do
      let!(:item1) { create(:item, group_id: group.id) }
      let!(:item2) { create(:item, group_id: group.id) }

      it { expect(response).to have_http_status(200) }

      it 'renders item titles' do
        expect(response.body).to include(item1.title)
        expect(response.body).to include(item2.title)
      end
    end

    context 'no data' do
      it { expect(response).to have_http_status(200) }

      it 'renders a stub' do
        expect(response.body).to include('Данных нет. Пожалуйста добавьте данные в лист')
      end
    end

    context 'wrond group id' do
      let!(:group) { build(:group, id: '123') }

      it { expect(response).to have_http_status(404) }
      it 'renders 404 page' do
        expect(response.body).to include('Страница не найдена')
      end
    end
  end
end

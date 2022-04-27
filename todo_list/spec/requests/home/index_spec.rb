# frozen_string_literal: true

MiniRSpec.describe 'Home' do
  describe 'GET /' do
    before_each { get '/' }

    context 'with data' do
      let!(:group1) { create(:group) }
      let!(:group2) { create(:group) }

      it { expect(response).to have_http_status(200) }

      it 'renders group titles' do
        expect(response.body).to include(group1.title)
        expect(response.body).to include(group2.title)
        expect(response.body).not_to include("You don't have any TODO list")
      end
    end

    context 'no data' do
      it { expect(response).to have_http_status(200) }

      it 'renders a stub' do
        expect(response.body).to include("You don't have any TODO list")
      end
    end
  end
end

# frozen_string_literal: true

MiniRSpec.describe 'Group' do
  describe 'DELETE /groups/:id' do
    let!(:group) { create(:group) }

    before_each { delete "/groups/#{group.id}" }

    it 'redirects to root' do
      expect(response).to have_http_status(303)
      expect(response.headers['Location']).to eq('/')
    end

    it 'deletes group' do
      expect(Group.all.count).to eq(0)
    end

    context 'invalid group id' do
      let!(:another_group) { create(:group) }
      let!(:group) { build(:group, id: '123') }

      it { expect(response).to have_http_status(404) }

      it "doesn't delete groups" do
        expect(Group.all.count).to eq(1)
      end

      it 'renders 404' do
        expect(response.body).to include('Not found. 404')
      end
    end
  end
end

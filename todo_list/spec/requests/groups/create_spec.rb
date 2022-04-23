# frozen_string_literal: true

MiniRSpec.describe 'Group' do
  describe 'POST /groups' do
    context 'valid data' do
      before_each { post '/groups', { title: 'Hello', description: 'World!' } }

      it 'redirects to root' do
        expect(response).to have_http_status(303)
        expect(response.headers['Location']).to eq('/')
      end

      it 'creates group' do
        expect(Group.all.count).to eq(1)
      end
    end

    context 'invalid data' do
      before_each { post '/groups', { title: '12' } }

      it { expect(response).to have_http_status(422) }

      it 'renders alert' do
        expect(response.body).to include('We are having troubles')
        expect(response.body).to include('Title must be greater then 3')
      end
    end
  end
end

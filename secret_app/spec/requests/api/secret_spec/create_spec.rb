# frozen_string_literal: true

MiniRSpec.describe 'Api::Secret' do
  describe 'POST api/secrets' do
    let!(:message) { 'my little secret' }

    before_each { post '/api/secrets', params }

    context 'without password' do
      let!(:params) { {message: message} }

      it 'creates item in DB' do
        expect(response).to have_http_status(201)
        expect(Secret.all.count).to eq(1)
      end

      it 'renders attributes' do
        expect(json['message']).to eq(message)
        expect(json['password']).to eq(nil)
        expect(json['view_limit']).to eq(0)
        expect(json['link']).to include(Secret.first.id)
      end
    end

    context 'with password' do
      let!(:params) { {message: message, with_password: true} }

      it 'sets password' do
        expect(json['password']).to eq(Secret.first.password)
      end
    end

    context 'with limits' do
      let!(:params) { {message: message, with_limit: true} }

      it 'sets limits' do
        expect(json['view_limit']).to eq(3)
      end
    end
  end
end

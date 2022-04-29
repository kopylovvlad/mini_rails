# frozen_string_literal: true

MiniRSpec.describe 'Api::Secret' do
  describe 'GET api/secrets/:id' do
    before_each { get "/api/secrets/#{id}", params }

    let!(:item) { create(:secret) }
    let!(:id) { item.id }
    let!(:params) { {} }

    it 'renders data' do
      expect(response).to have_http_status(200)
      expect(json['message']).to eq(item.message)
    end

    context 'fake id' do
      let!(:id) { build(:secret, id: '111').id }

      it 'renders error' do
        expect(response).to have_http_status(404)
        expect(json['error']).to eq('not_found')
      end
    end

    context 'with password' do
      let!(:item) { create(:secret, :with_password) }

      context 'password is correct' do
        let!(:params) { { password: item.password } }

        it 'renders data' do
          expect(response).to have_http_status(200)
          expect(json['message']).to eq(item.message)
        end
      end

      context "password isn't correct" do
        let!(:params) { { password: '1234' } }

        it 'renders error' do
          expect(response).to have_http_status(403)
          expect(json['error']).to eq('it requires password')
        end
      end
    end

    context 'with limits' do
      let!(:item) { create(:secret, :with_limits) }

      it 'renders data' do
        expect(response).to have_http_status(200)
        expect(json['message']).to eq(item.message)
      end

      context 'views increasing' do
        it 'increases views' do
          expect(Secret.find(id).current_views).to eq(1)
          get "/api/secrets/#{id}", params
          expect(Secret.find(id).current_views).to eq(2)
        end
      end

      context 'full limits' do
        let!(:item) { create(:secret, :full_limits) }

        it 'renders error' do
          expect(response).to have_http_status(403)
          expect(json['error']).to eq('out of limits')
        end
      end
    end
  end
end

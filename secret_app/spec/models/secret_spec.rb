# frozen_string_literal: true

MiniRSpec.describe 'Secret' do
  describe '#view_limit' do
    context 'default value' do
      it { expect(Secret.new.view_limit).to eq(0) }
    end
  end

  describe '#password?' do
    context 'item with pass' do
      let!(:item) { build(:secret, :with_password) }
      it { expect(item.password?).to be_truthy }
    end

    context 'item without pass' do
      let!(:item) { build(:secret, password: '') }
      it { expect(item.password?).to be_falsey }
    end

    context 'pass is nil' do
      let!(:item) { build(:secret, password: nil) }
      it { expect(item.password?).to be_falsey }
    end
  end

  describe '#view_limit?' do
    context 'item with limits' do
      let!(:item) { build(:secret, :with_limits) }
      it { expect(item.view_limit?).to be_truthy }
    end

    context 'limit is 0' do
      let!(:item) { build(:secret, view_limit: 0) }
      it { expect(item.view_limit?).to be_falsey }
    end
  end

  describe '#out_of_limits?' do
    context 'item with limits' do
      let!(:item) { build(:secret, :with_limits) }
      it { expect(item.out_of_limits?).to be_falsey }
    end

    context 'out of limits' do
      let!(:item) { build(:secret, :full_limits) }
      it { expect(item.out_of_limits?).to be_truthy }
    end
  end

  context '#increase_views!' do
    let!(:item) { build(:secret, :with_limits) }

    it 'increases views' do
      expect(item.current_views).to eq(0)
      item.increase_views!
      expect(item.current_views).to eq(1)
    end
  end
end

# frozen_string_literal: true

MiniRSpec.describe 'Group' do
  context 'factory' do
    context 'create one item' do
      let!(:group) { create(:group) }

      it 'works' do
        expect(group.id).to be_present
        expect(group.items).not_to be_present
      end
    end

    context 'create few items' do
      before_each { create_list(:group, 3) }

      it 'works' do
        expect(Group.all.count).to eq(3)
      end
    end
  end

  context 'quering' do
    it 'returns MiniActiveRecord::Proxy' do
      expect(Group.all).to be_kind_of(::MiniActiveRecord::GroupProxy)
    end

    context '#find_by' do
      before_each { create_list(:group, 2) }
      let!(:group) { create(:group, title: 'my_group') }
      let!(:item) { Group.find_by(title: 'my_group') }

      it 'finds item' do
        expect(item.id).to eq(group.id)
      end
    end
  end

  context 'relations' do
    let!(:group) { create(:group, :with_item) }
    let!(:items) { create_list(:item, 2, group_id: group.id) }

    it 'works' do
      expect(group.items.size).to eq(2)
    end
  end

  context 'validations' do
    describe '#title' do
      it 'should be present' do
        group = build(:group, title: nil)
        expect(group.title).to be_nil
        expect(group.valid?).to be_falsey
        expect(group.errors[:title]).to include('must be present')
      end

      it 'can not be less then 3' do
        group = build(:group, title: '1')
        expect(group.valid?).to be_falsey
        expect(group.errors[:title]).to include('must be greater then 3')
      end

      it 'can not be more then 100' do
        group = build(:group, title: '1'*101)
        expect(group.valid?).to be_falsey
        expect(group.errors[:title]).to include('must be less then 100')
      end
    end

    describe '#description' do
      it 'can not be less then 3' do
        group = build(:group, description: '1')
        expect(group.valid?).to be_falsey
        expect(group.errors[:description]).to include('must be greater then 3')
      end

      it 'can not be more then 100' do
        group = build(:group, description: '1'*101)
        expect(group.valid?).to be_falsey
        expect(group.errors[:description]).to include('must be less then 100')
      end
    end
  end

  context '#items' do
    let!(:group1) { create(:group) }
    let!(:group2) { create(:group) }
    let!(:items) { create_list(:item, 3, group_id: group1.id) }

    it 'returns items' do
      create(:item, group_id: group2.id)
      expect(group1.items.count).to eq(3)
      expect(group2.items.count).to eq(1)
    end
  end
end

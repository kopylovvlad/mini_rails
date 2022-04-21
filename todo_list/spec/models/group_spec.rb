# frozen_string_literal: true

MiniRSpec.describe 'Group' do
  context 'factory' do
    it 'works' do
      group = create(:group)
      expect(group.id).to be_present
      expect(group.items).not_to be_present
    end

    context 'create few items' do
      it 'works' do
        create_list(:group, 3)
        expect(Group.all.count).to eq(3)
      end
    end
  end

  context 'quering' do
    context '#find_by' do
      it 'find item' do
        create_list(:group, 2)
        group = create(:group, title: 'my_group')
        item = Group.find_by(title: 'my_group')
        expect(item.id).to eq(group.id)
      end
    end
  end

  context 'relations' do
    it 'works' do
      group = create(:group, :with_item)
      items = create_list(:item, 2, group_id: group.id)
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
    it 'returns items' do
      group1 = create(:group)
      group2 = create(:group)
      items = create_list(:item, 3, group_id: group1.id)
      create(:item, group_id: group2.id)
      expect(group1.items.count).to eq(3)
      expect(group2.items.count).to eq(1)
    end
  end
end

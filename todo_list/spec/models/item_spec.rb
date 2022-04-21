# frozen_string_literal: true

MiniRSpec.describe 'Item' do
  context 'factories' do
    it 'works' do
      item = create(:item)
      expect(item.id).to be_present
      expect(item.done).to be_falsey
      expect(item.group_id).to be_nil
    end

    context 'done' do
      it 'works' do
        item = create(:item, :done)
        expect(item.done).to be_truthy
      end
    end

    context 'with group' do
      it 'works' do
        item = create(:item, :with_group)
        expect(item.group_id).to be_present
        expect(item.group).to be_kind_of(::Group)
      end
    end
  end

  context 'validation' do
    describe '#title' do
      it "can't be less then 3" do
        item = build(:item, title: '1')
        expect(item.valid?).to be_falsey
        expect(item.errors[:title]).to include('must be greater then 3')
      end

      it "can't be more then 100" do
        item = build(:item, title: '1'*101)
        expect(item.valid?).to be_falsey
        expect(item.errors[:title]).to include('must be less then 100')
      end
    end
  end

  context 'scopes' do
    describe '.active' do
      it 'returns active items' do
        group = create(:group)
        active_items = create_list(:item, 2, group_id: group.id)
        not_active_items = create_list(:item, 3, :done, group_id: group.id)
        expect(group.items.count).to eq(5)
        expect(group.items.active.count).to eq(2)
      end
    end

    describe '.not_active' do
      it 'returns not active items' do
        group = create(:group)
        active_items = create_list(:item, 2, group_id: group.id)
        not_active_items = create_list(:item, 3, :done, group_id: group.id)
        expect(group.items.count).to eq(5)
        expect(group.items.not_active.count).to eq(3)
      end
    end
  end
end

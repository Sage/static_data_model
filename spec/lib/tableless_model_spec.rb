# frozen_string_literal: true

RSpec.describe TablelessModel do
  it 'has a version number' do
    expect(TablelessModel::VERSION).not_to be nil
  end

  let(:dummy_class) do
    Class.new do
      include TablelessModel

      self.data_store = [
        {
          id: 1, name: 'dummy 1'
        }, {
          id: 2, name: 'dummy 2'
        }, {
          id: 3, name: 'dummy 3', desc: 'this is n° 3'
        }
      ]
    end
  end

  context 'when an attribute only figures in one object in the data_store' do
    it 'still is a valid attribute in every instance' do
      expect(dummy_class.new).to respond_to :desc
    end
  end

  describe '.all' do
    it 'returns all the data defined in the data_store' do
      records = dummy_class.all
      expect(records.size).to be 3
      expect(records.first.name).to eq 'dummy 1'
      expect(records.last.desc).to eq 'this is n° 3'
    end
  end

  describe '.find(id)' do
    context 'when found' do
      it 'has found the object belonging to "id"' do
        expect(dummy_class.find(2).name).to eq 'dummy 2'
      end
    end

    context 'when not found' do
      it 'raises an error' do
        expect { dummy_class.find(4) }.to raise_error
      end
    end
  end
end

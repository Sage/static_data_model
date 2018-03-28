# frozen_string_literal: true

require 'active_record'

RSpec.describe StaticDataModel do
  it 'has a version number' do
    expect(StaticDataModel::VERSION).not_to be nil
  end

  let(:dummy_class) do
    Class.new do
      include StaticDataModel

      self.model_data = [
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

  context 'when an attribute only figures in one object in the model_data' do
    it 'still is a valid attribute in every instance' do
      expect(dummy_class.new).to respond_to :desc
    end
  end

  context 'when initialised with unknown keys' do
    it 'raises an exception' do
      expect { dummy_class.new({ unknown: :foo }) }.to raise_error(/does not accept keys \[\:unknown\]/)
    end
  end

  describe '.all' do
    it 'returns all the data defined in the model_data' do
      records = dummy_class.all
      expect(records.size).to be 3
      expect(records.first.name).to eq 'dummy 1'
      expect(records.last.desc).to eq 'this is n° 3'
    end
  end

  describe '.find(id)' do
    context 'when found' do
      it 'returns the object belonging to "id"' do
        expect(dummy_class.find(2).name).to eq 'dummy 2'
      end
    end

    context 'when not found' do
      context 'and raises_activerecord_errors has been called on the class' do
        before do
          dummy_class.raises_activerecord_errors
        end

        it 'raises ActiveRecord::RecordNotFound' do
          expect { dummy_class.find(4) }
            .to raise_error(ActiveRecord::RecordNotFound, /with ID 4/)
        end
      end

      context 'and raises_activerecord_errors has never been called' do
        it 'raises StaticDataModel::Errors::RecordNotFound' do
          expect { dummy_class.find(4) }
            .to raise_error(Errors::RecordNotFound, /with ID 4/)
        end
      end
    end
  end
end

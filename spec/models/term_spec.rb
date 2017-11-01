require 'rails_helper'

RSpec.describe Term, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:term)).to be_valid
  end
  it 'is invalid without a season' do
    term = FactoryBot.build(:term, season: nil)
    expect(term).to be_invalid
  end
  it 'is invalid without a year' do
    term = FactoryBot.build(:term, year: nil)
    expect(term).to be_invalid
  end
  it 'is invalid if season is not SSTerm or WSTerm' do
    term = FactoryBot.build(:term, season: 'Spring')
    expect(term).to be_invalid
  end
  it 'is invalid if year is not a number' do
    term = FactoryBot.build(:term, year: 'hello')
    expect(term).to be_invalid
  end
  it 'is invalid if year is not an integer' do
    term = FactoryBot.build(:term, year: 2017.25)
    expect(term).to be_invalid
  end
  it 'is invalid if year is lower than 2000' do
    term = FactoryBot.build(:term, year: 1999)
    expect(term).to be_invalid
  end
  it 'is invalid if year is higher than 2200' do
    term = FactoryBot.build(:term, year: 2201)
    expect(term).to be_invalid
  end
  it 'is invalid with duplicate season and year' do
    FactoryBot.create(:term, season: 'SS', year: 2017)
    term = FactoryBot.build(:term, season: 'SS', year: 2017)
    expect(term).to be_invalid
  end
  describe '#begin_date' do
    context 'if the term is a winter term' do
      it 'returns the correct begin date' do
        term = FactoryBot.build(:term, season: 'WS', year: 2017)
        expect(term.begin_date).to eq Date.new(2017, 10, 1)
      end
    end
    context 'if the term is a summer term' do
      it 'returns the correct begin date' do
        term = FactoryBot.build(:term, season: 'SS', year: 2017)
        expect(term.begin_date).to eq Date.new(2017, 4, 1)
      end
    end
  end
  describe '#end_date' do
    context 'if the term is a winter term' do
      it 'returns the correct end date' do
        term = FactoryBot.build(:term, season: 'WS', year: 2017)
        expect(term.end_date).to eq Date.new(2018, 3, 31)
      end
    end
    context 'if the term is a summer term' do
      it 'returns the correct end date' do
        term = FactoryBot.build(:term, season: 'SS', year: 2017)
        expect(term.end_date).to eq Date.new(2017, 9, 30)
      end
    end
  end
end

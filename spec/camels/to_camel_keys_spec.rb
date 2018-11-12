require 'spec_helper'
require 'camels/to_camel_keys'

RSpec.describe Camels::ToCamelKeys do
  subject(:camelized) { interactor.call(value: hash, acronyms: acronyms) }

  let(:interactor) { described_class.new }
  let(:acronyms) { {} }

  context 'with a simple hash' do
    let(:hash) do
      { "first_key" => "fooBar" }
    end

    it 'camelizes the key' do
      expect(camelized.keys.first).to eq("FirstKey")
    end

    it "leaves the key as a string" do
      expect(camelized.keys.first).to be_a(String)
    end

    it "leaves the value untouched" do
      expect(camelized.values.first).to eq("fooBar")
    end

    it "leaves the original hash untouched" do
      expect(hash.keys.first).to eq("first_key")
    end
  end

  context 'with embedded hashes' do
    let(:hash) do
      {
        "apple_type" => "Granny Smith",
        "vegetable_types" => [
          { "potato_type" => "Golden delicious" },
          { "other_tuber_type" => "peanut" },
          { "peanut_names_and_spouses" => [
            { "bill_the_peanut" => "sally_peanut" },
            { "sammy_the_peanut" => "jill_peanut" }
          ] }
        ]
      }
    end

    it "recursively camelizes the keys on the top level of the hash" do
      expect(camelized.keys).to include("AppleType", "VegetableTypes")
    end

    it "leaves the values on the top level alone" do
      expect(camelized["AppleType"]).to eq("Granny Smith")
    end

    it "converts second-level keys" do
      expect(camelized["VegetableTypes"].first).to have_key("PotatoType")
    end

    it "leaves second-level values alone" do
      expect(camelized["VegetableTypes"].first).to have_value("Golden delicious")
    end

    it "converts third-level keys" do
      expect(camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].first).to have_key("BillThePeanut")
    end

    it "leaves third-level values alone" do
      expect(camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].first["BillThePeanut"]).to eq("sally_peanut")
    end
  end

  context 'with a key that is an acronym' do
    let(:acronyms) do
      { "id" => "ID" }
    end

    let(:hash) do
      { "user_id" => "1" }
    end

    it "camelizes the acronym" do
      expect(camelized.keys.first).to eq("UserID")
    end

    context 'when entire key is acronym' do
      let(:hash) do
        { "id" => "1" }
      end

      it "capitalizes the acronym" do
        expect(camelized.keys.first).to eq("ID")
      end
    end

    context 'with acronym as part of another word' do
      let(:hash) do
        { "idee" => "1" }
      end

      it 'matches on word boundaries' do
        expect(camelized.keys.first).to eq("Idee")
      end
    end
  end
end

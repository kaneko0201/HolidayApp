require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    let(:valid_user) { User.new(start_date: Date.today, end_date: Date.today + 3, people: 2, budget: 10000, location: "東京都渋谷区", mood: "リラックスしたい") }

    context "必須項目のバリデーション" do
      it "すべての項目が正しく入力されていれば有効" do
        expect(valid_user).to be_valid
      end

      it "start_date が空だと無効" do
        valid_user.start_date = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:start_date]).to include("を入力してください")
      end

      it "end_date が空だと無効" do
        valid_user.end_date = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:end_date]).to include("を入力してください")
      end

      it "people が空だと無効" do
        valid_user.people = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:people]).to include("を入力してください")
      end

      it "budget が空だと無効" do
        valid_user.budget = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:budget]).to include("を入力してください")
      end

      it "location が空だと無効" do
        valid_user.location = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:location]).to include("を入力してください")
      end

      it "mood が空だと無効" do
        valid_user.mood = nil
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:mood]).to include("を入力してください")
      end
    end

    context "日付バリデーションのテスト" do
      it "end_date が start_date 以降なら有効" do
        valid_user.end_date = valid_user.start_date + 1
        expect(valid_user).to be_valid
      end

      it "end_date が start_date より前だと無効" do
        valid_user.end_date = valid_user.start_date - 1
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:end_date]).to include("は開始日以降の日付を選択してください")
      end

      it "end_date が start_date から5日以内なら有効" do
        valid_user.end_date = valid_user.start_date + 5
        expect(valid_user).to be_valid
      end

      it "end_date が start_date から6日以上だと無効" do
        valid_user.end_date = valid_user.start_date + 6
        expect(valid_user).to be_invalid
        expect(valid_user.errors[:end_date]).to include("は開始日から5日以内の日付を選択してください")
      end
    end
  end
end

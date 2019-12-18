require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーa', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーb', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーaが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }

  end

  describe '一覧表示機能' do
    context 'ユーザーaがログインしている時' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーaが作成したタスクが表示される'
    end

    context 'ユーザーbがログインしている時' do
      let(:login_user) { user_b }

      it 'ユーザーaが作成したタスクが表示されない' do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーaがログインしている時' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーaが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      # 新規作成画面で
      visit new_task_path
      fill_in '名前', with: task_name
      click_button '確認'
      # 確認画面で登録ボタンを押す
      click_button '登録'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く' # class="alert-success"のtextが...
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do # id="error_explanation"の中で...
          expect(page).to have_content '名前を入力してください'
        end
      end
    end
  end
end
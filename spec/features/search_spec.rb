require 'spec_helper.rb'

feature 'Looking up courses', js: true do
  before do
    Course.create!(name: 'MATH 1004')
    Course.create!(name: 'MATH 1104')
    Course.create!(name: 'SYSC 1005')
    Course.create!(name: 'COMP 3005')
  end

  scenario 'finding courses' do
    visit '/'
    fill_in 'keywords', with: 'math'
    click_on 'Search'

    expect(page).to have_content('MATH 1004')
    expect(page).to have_content('MATH 1104')
  end
end

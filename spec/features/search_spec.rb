require 'spec_helper.rb'

feature 'Looking up courses', js: true do
  before do
    Course.create!(name: 'Calculus 1')
    Course.create!(name: 'Linear Algebra')
    Course.create!(name: 'Intro to Programming')
    Course.create!(name: 'Databases')
  end

  scenario 'finding courses' do
    visit '/'
    fill_in 'keywords', with: 'al'
    click_on 'Search'

    expect(page).to have_content('Calculus 1')
    expect(page).to have_content('Linear Algebra')
  end
end

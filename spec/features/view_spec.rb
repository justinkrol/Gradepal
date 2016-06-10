require 'spec_helper.rb'

feature 'Viewing a course', js: true do
  before do
    Course.create!(name: 'Calculus 1',
                   code: 'MATH 1004')

    Course.create!(name: 'Linear Algebra',
                   code: 'MATH 1104')
  end
  scenario 'view one course' do
    visit '/'
    fill_in 'keywords', with: 'linear'
    click_on 'Search'

    click_on 'Linear Algebra'

    expect(page).to have_content('Linear Algebra')
    expect(page).to have_content('MATH 1104')

    click_on 'Back'

    expect(page).to     have_content('Linear Algebra')
    expect(page).to_not have_content('MATH 1104')
  end
end

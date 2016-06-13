require 'spec_helper.rb'

feature 'Creating, editing, and deleting a course', js: true do
  scenario 'CRUD a course' do
    visit '/'
    click_on 'New course'

    fill_in 'name', with: 'Intro to Programming'
    fill_in 'code', with: 'SYSC 1005'

    click_on 'Save'

    expect(page).to have_content('Intro to Programming')
    expect(page).to have_content('SYSC 1005')

    click_on 'Edit'

    fill_in 'name', with: 'Operating Systems'
    fill_in 'code', with: 'SYSC 4001'

    click_on 'Save'

    expect(page).to have_content('Operating Systems')
    expect(page).to have_content('4001')

    visit '/'
    fill_in 'keywords', with: 'Operating'
    click_on 'Search'

    click_on 'Operating Systems'

    click_on 'Delete'

    expect(Course.find_by_name('Operating Systems')).to be_nil
  end
end

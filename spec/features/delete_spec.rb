require 'spec_helper.rb'

feature 'Deleting a course from the index page', js: true do
  scenario 'Delete a course' do
    visit '/'
    click_on 'New course'

    fill_in 'name', with: 'Intro to Programming'
    fill_in 'code', with: 'SYSC 1005'

    click_on 'Save'

    expect(page).to have_content('Intro to Programming')
    expect(page).to have_content('SYSC 1005')

    visit '/'
    fill_in 'keywords', with: ''
    click_on 'Search'

    expect(page).to have_content('Intro to Programming')

    # TODO Find a new way to click the proper delete button
    click_on('Delete') # This only works if there's only one course! BAD

    expect(page).to_not have_content('Intro to Programming')
    expect(Course.find_by_name('Intro to Programming')).to be_nil
  end
end

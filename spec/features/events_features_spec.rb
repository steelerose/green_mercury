require 'spec_helper'

feature 'create events' do
  before :each do
    @user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    EventsController.any_instance.stub(:current_user).and_return(@user)
    visit new_event_path
  end

  scenario 'user creates an event with valid information' do
    fill_in 'event_title', with: 'This Thing'
    fill_in 'event_description', with: 'We do things'
    fill_in 'event_location', with: 'That place'
    fill_in 'event_date', with: Date.today
    fill_in 'event_start_time', with: Time.now
    fill_in 'event_end_time', with: (Time.now + 1.hour)
    click_button('Create Event')
    page.should have_content "Your event has been created."
  end

  scenario 'user creates an event with invalid information' do
    click_button('Create Event')
    page.should have_content 'error'
  end
end

feature 'view an event'do
  scenario 'user views an event page' do
    user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    EventsController.any_instance.stub(:current_user).and_return(user)
    event = FactoryGirl.create(:event)
    visit event_path(event)
    page.should have_content event.title
  end
end

feature 'view all events' do
  scenario 'user views all events' do
    user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    EventsController.any_instance.stub(:current_user).and_return(user)
    @event1 = FactoryGirl.create(:event, title: 'Event 1')
    @event2 = FactoryGirl.create(:event, title: 'Event 2')
    visit events_path
    page.should have_content @event1.title
    page.should have_content @event2.title
  end
end

feature 'delete an event' do
  scenario 'user deletes an event' do
    user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    EventsController.any_instance.stub(:current_user).and_return(user)
    event = FactoryGirl.create(:event)
    visit event_path event
    click_link 'Delete event'
    visit events_path
    page.should_not have_content event.title
  end
end

feature 'edit an event' do
  before :each do
    @user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    EventsController.any_instance.stub(:current_user).and_return(@user)
    @event = FactoryGirl.create(:event)
    visit event_path @event
    click_link 'Edit event'
  end

  scenario 'user edits an event with valid information' do
    fill_in 'event_location', with: 'That other place'
    click_button('Confirm changes')
    page.should have_content "That other place"
  end

  scenario 'user edit an event with invalid information' do
    fill_in 'event_location', with: ""
    click_button('Confirm changes')
    page.should have_content "error"
  end
end

feature 'RSVP to an event' do
  before :each do
    @user = FactoryGirl.build(:user)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    EventsController.any_instance.stub(:current_user).and_return(@user)
    EventRsvpsController.any_instance.stub(:current_user).and_return(@user)
    @event = FactoryGirl.create(:event)
    visit event_path @event
    click_button 'RSVP for this event'
  end

  scenario 'user RSVPs for an event' do
    page.should have_content @user.name
  end

  scenario 'user removes their RSVP for an event' do
    click_button 'Cancel RSVP'
    page.should_not have_content @user.name
  end
end












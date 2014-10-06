require 'spec_helper'

feature "user signs in", js: true do

	before do
		@season = Season.create(year: 2014, name: "2014 Season", entry_fee: 50)
    @week = Week.create(season: @season, week_number: 1, start_date: DateTime.new(2014, 8, 5), deadline: DateTime.new(2014, 8, 8), end_date: DateTime.new(2014, 8, 11))
    @webstate = WebState.create(week_id: @week.id)
    @pool_entry1 = PoolEntry.create(user: @user, team_name: "Test Team", paid: true)

    @broncos = NflTeam.create(name: "Denver Broncos", conference: "NFC", division: "West")
    @vikings = NflTeam.create(name: "Minnesota Vikings", conference: "NFC", division: "North")
    @matchup = Matchup.create(week_id: @week.id, home_team: @broncos, away_team: @vikings, game_time: DateTime.new(2014,8,10,11))
	end
	
	scenario "with valid email and password" do
		user = create(:user)
    visit root_path
    fill_in 'sign_on_field', with: user.email
    fill_in 'password_field', with: user.password

    click_button("Sign In")

    expect(page).not_to have_content("Sign In")
    expect(page).to have_content(user.email)
	end
end
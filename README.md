# Running in development
### Install & Run
`git clone https://github.com/srinjoyc/booking-system.git`
`bundle install`
`rake db:setup`
`rails s`
### Test
`bundle exec rspec --format documentation`
`Code coverage 90%, /coverage/index.html`
### Routes
`/ => Sample Front-End for finding the fastest table`
`/create-reservation => API to create a reservation as per requirements`
`/reservations/restaurant/:id => API to get all reservations of a restaurant as per requirements`
`/admin => Admin view of all models in the database with CRUD operations`

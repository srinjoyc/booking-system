require 'rails_helper'
RSpec.describe GuestsController, type: :controller do

# Sample guest already in database
before :example do
  Guest.create!({
    name: 'Srinjoy',
    email: 'srinjoy@live.ca'
  })
end

# SHOW
describe 'Get a specific user by id' do

  context 'user is already in db' do
    it 'finds the correct user and returns it.' do
      guest = Guest.first
      get :show, params: {:id => "#{guest.id.to_json}"}
      resp = json(response)
      expect(resp.key?('email') && resp.key?('name')).to eq(true)
      expect(resp['email']).to eq("srinjoy@live.ca")
    end
  end

  context 'user not in db - invalid id' do
    it 'returns a not found error' do
      get :show, params: {:id => "1000"}
      resp = json(response)
      puts resp
      expect(resp.key?('error')).to eq(true)
      expect(resp['error']).to eq("Couldn\'t find Guest with 'id'=1000")
    end
  end

end

# INDEX
describe 'Get all users' do

  context 'User in db' do
    it 'updates the correct user and returns it.' do
      get :index
      resp = json(response)
      expect(resp[0]['email']).to eq("srinjoy@live.ca")
    end
  end

end

# CREATE
  describe 'Creating users' do

    context 'with valid attributes' do
      it 'creates a new user and returns it.' do
        params = {
          guest: {
            name: 'George',
            email: 'geroge@live.ca'
          }
        }
        post :create, params: params
        resp = json(response) # constructs ruby object from response - defined below
        expect(resp.key?('email') && resp.key?('name')).to eq(true)
        expect(Guest.count).to eq(2)
      end
    end

    context 'with duplicate attributes' do
      it 'creates a new user and returns it.' do
        params = {
          guest: {
            name: 'George', # different name
            email: 'srinjoy@live.ca' # same email
          }
        }
        post :create, params: params
        resp = json(response)
        # EXPECTED: {"email"=>["has already been taken"]}
        expect(resp.key?('email')).to eq(true)
        expect(resp['email'][0]).to eq("has already been taken")
        expect(Guest.count).to eq(1) # No new users created
      end
    end

    context 'with invalid attributes' do
      it 'returns an error message saying the email is invalid' do
        params = {
          guest: {
            name: 'George',
            email: 'not-an-email' # does not match email regex
          }
        }
        post :create, params: params
        resp = json(response)
        # EXPECTED: {"email"=>["has already been taken"]}
        expect(resp.key?('email')).to eq(true)
        expect(resp['email'][0]).to eq("is invalid")
        expect(Guest.count).to eq(1) # No new users created
      end
      it 'returns an error message saying the name cant be blank' do
        params = {
          guest: {
            name: '',
            email: 'srinjoy123@live.ca' # does not match email regex
          }
        }
        post :create, params: params
        resp = json(response)
        puts resp
        # EXPECTED: {"email"=>["has already been taken"]}
        expect(resp.key?('name')).to eq(true)
        expect(resp['name'][0]).to eq("can't be blank")
        expect(Guest.count).to eq(1) # No new users created
      end
    end

  end

# UPDATE
  describe 'Updating users' do

    context 'with valid attributes' do
      it 'updates the correct user and returns it.' do
        guest = Guest.first
        params = {
          id: guest.id,
          guest: {
            email: 'new-email@live.ca'
          }
        }
        put :update, params: params
        guest = Guest.first # get the guest after the update
        expect(guest.email).to eq('new-email@live.ca')
        expect(Guest.count).to eq(1) # No new users created
      end
    end

    context 'with invalid attributes' do
      it 'updates the correct user and returns it.' do
        guest = Guest.first
        params = {
          id: guest.id,
          guest: {
            email: 'new-em'
          }
        }
        put :update, params: params
        resp = json(response)
        guest = Guest.first
        expect(resp['email'][0]).to eq("is invalid")
        expect(guest.email).to eq('srinjoy@live.ca')
      end
    end

  end

# DELETE
  describe 'Delete a specifc user by id' do
    context 'valid id' do
      it 'deletes the user.' do
        guest = Guest.first
        params = {
          id: guest.id,
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
        expect(Guest.count).to eq(0)
      end
    end
  end

end

private
  def json response
    JSON.parse response.body
  end

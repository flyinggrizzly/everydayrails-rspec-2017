require 'rails_helper'

RSpec.describe User, type: :model do
  
  def user_details(first_name: 'Howard',
                   last_name:  'Lovecraft',
                   email:      'hpl@cthulhu.ichor',
                   password:   'hasturhasturhastur')
     { first_name: first_name,
       last_name:  last_name,
       email:      email,
       password:   password }
  end

  it 'is valid with a first name, last name, email, and password' do
    user = User.new(user_details)
    expect(user).to be_valid
  end

  it 'is invalid without a first name', :aggregate_failures do
    user = User.new(user_details(first_name: nil))
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name', :aggregate_failures do
    user = User.new(user_details(last_name: nil))
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid without an email', :aggregate_failures do
    user = User.new(user_details(email: nil))
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password', :aggregate_failures do
    user = User.new(user_details(password: ''))
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address', :aggregate_failures do
    # Set up a user to force email clash
    User.create(user_details)

    user = User.new(user_details)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "returns a user's full name as a string" do
    user = User.create(user_details)
    expect(user.name).to eq("#{user_details[:first_name]} #{user_details[:last_name]}")
  end
end

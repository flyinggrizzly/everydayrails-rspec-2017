require 'rails_helper'

RSpec.describe Project, type: :model do

  def user_details(first_name: 'Howard',
                   last_name:  'Lovecraft',
                   email:      'hpl@cthulhu.ichor',
                   password:   'hasturhasturhastur')
    { first_name: first_name,
      last_name:  last_name,
      email:      email,
      password:   password }
  end

  it 'does not allow duplicate project names per user' do
    user = User.create(user_details)
    user.projects.create(name: 'Test Project')

    new_project = user.projects.build(name: 'Test Project')
    expect(new_project).not_to be_valid
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  it 'allows two users to share a project name' do
    howard = User.create(user_details)
    august = User.create(user_details(first_name: 'August',
                                      last_name:  'Derleth',
                                      email:      'ad@cthulhu.ichor',
                                      password:   'goofballgoofball'))

    howard.projects.create(name: 'Necronomicon')
    augusts_necronomicon = august.projects.build(name: 'Necronomicon')

    expect(augusts_necronomicon).to be_valid
  end

  it 'is not valid without a name' do
    user = User.create(user_details)
    project = user.projects.build(name: '')
    expect(project).not_to be_valid
  end
end

require 'rails_helper'

RSpec.describe Note, type: :model do

  def user_details(first_name: 'Howard',
                   last_name:  'Lovecraft',
                   email:      'hpl@cthulhu.ichor',
                   password:   'hasturhasturhastur')
    { first_name: first_name,
      last_name:  last_name,
      email:      email,
      password:   password }
  end

  it 'returns notes that match the search term', :aggregate_failures do
    user = User.create(user_details)
    project = user.projects.create(name: 'Test Project')
    note1 = project.notes.create(message: 'This is the first note.',
                                 user:    user)
    note2 = project.notes.create(message: 'This is the second note.',
                                 user:    user)
    note3 = project.notes.create(message: 'First, preheat the oven.',
                                 user:    user)

    expect(Note.search('first')).to include note1, note3
    expect(Note.search('first')).not_to include note2
  end
end

include FactoryGirl::Syntax::Methods

boston = create(:district, name: 'Boston Public Schools', slug: 'boston')
create(:school,
  district: boston,
  name: 'Samuel Adams Elementary',
  address: '165 East Webster St, East Boston, MA'
)
create(:school,
  district: boston,
  name: 'Jeremiah E. Burke High',
  address: '60 Washington St, Dorchester, MA'
)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '	269346943176907', '9d3a9a47d7dda2e52aec6fb0a24901ca',
  :scope => 'email, user_birthday, friends_birthday, user_photos, user_relationships, user_photos, friends_photos'
end
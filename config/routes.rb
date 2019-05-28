Rails.application.routes.draw do
  get 'recent_problems/create'
  get 'recent_problems/destroy'
  get 'problems/create'
  get 'problems/destroy'
  get 'users/follow'
  get 'users/remove'
  get 'get', to: 'users#get_problems'
end

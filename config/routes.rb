Nci::Application.routes.draw do
  root to: 'platforms#index'

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    invitations:   'users/invitations' }
  resources :users, only: [:index, :edit, :update, :show, :destroy] do
    post :toggle_archived, on: :member
    collection do
      get '/users/:id/edit_from_my_queue' => 'users#edit_from_my_queue', as: :edit_from_my_queue
    end
  end

  get 'admin/' => 'admin#index'

  resources :forums, except: [:edit] do
    collection do
      get  'filter'
      get  'select'
      post 'select_to_edit'
    end
  end
  resources :topics, except: [:index, :edit] do
    collection do
      get  'select'
      post 'select_to_edit'
    end
  end
  resources :posts, except: [:index, :new, :show]

  resources :announcements, except: [:new, :show]
  resources :messages, only: [:index]

  resources :leads, only: [:index, :edit, :update, :show], path: 'my-queue' do
    collection do
      get 'leads/:id/download_quote' => 'leads#download_quote', as: :download_quote
      get 'leads/:id/email_quote'    => 'leads#email_quote',    as: :email_quote
    end
  end

  resources :planned_subjects, only: [:index], path: 'my-plan' do
    collection do
      post 'toggle'
    end
  end

  resources :platforms do
    resources :categories, except: [:edit] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
    resources :subjects, except: [:edit], path: 'certifications' do
      collection do
        get  'select'
        post 'select_to_edit'
      end
      resources :groups, except: [:index, :show]
    end
    resources :dividers, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
    resources :exam_and_course_dynamics, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
    resources :exams, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
        get  'autocomplete_exam_title'
        get  'return_all'
      end
    end
    resources :courses, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
        get  'autocomplete_course_title'
        get  'return_all'
      end
    end
    resources :custom_items, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
  end

  resources :brands, except: :destroy

  get  'new-search'                                  => 'subjects#new_search'
  get  'search'                                      => 'subjects#search'
  get  'contact_us'                                  => 'general#contact_us_new'
  post 'contact_us'                                  => 'general#contact_us_create'
  get  'exams/search/:query'                         => 'exams#search',                   as: :exam_search
  get  'platforms/:platform_id/group_items/selector' => 'group_items#selector',           as: :group_item_selector
  post 'brand_users/change_role'                     => 'brand_users#change_role',        as: :change_role
  get  'brand_users/roles/:id'                       => 'brand_users#roles',              as: :roles
  post 'chosen_courses/toggle_active'                => 'chosen_courses#toggle_active',   as: :toggle_chosen_course_active
  post 'chosen_courses/toggle_attended'              => 'chosen_courses#toggle_attended', as: :toggle_chosen_course_attended
  post 'passed_exams/toggle'                         => 'passed_exams#toggle',            as: :toggle_passed_exam
  post 'request-quote'                               => 'leads#request_quote',            as: :request_quote
end

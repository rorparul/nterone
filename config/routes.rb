Nci::Application.routes.draw do
  root to: 'general#welcome'

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    invitations:   'users/invitations' }

  resources :users, only: [:index, :edit, :update, :show, :destroy] do
    post :toggle_archived, on: :member
    collection do
      get '/users/:id/edit_from_my_queue' => 'users#edit_from_my_queue', as: :edit_from_my_queue
      get 'page'
    end
  end

  get 'admin/' => 'admin#index'

  resources :pages

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

  resources :testimonials, except: [:show] do
    collection do
      get 'page'
    end
  end

  resources :carousel_items do
    collection do
      get 'page'
    end
  end

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

  resources :platforms, path: 'training' do
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
    resources :courses, except: [:index, :edit] do
      collection do
        get  'select'
        post 'select_to_edit'
        get  'autocomplete_course_title'
        get  'return_all'
        get  'courses/:id/download'      => 'courses#download',      as: :course_download
        get  'courses/:id/video_preview' => 'courses#video_preview', as: :course_video_preview
      end
      resources :events do
        collection do
          get  'select'
          post 'select_to_edit'
        end
      end
    end
    resources :video_on_demands, path: 'video-on-demand' do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
    resources :custom_items, except: [:index, :edit, :show] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
    resources :instructors do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end
  end

  controller :my_admin do
    get 'my-admin/classes',       as: :my_admin_classes
    get 'my-admin/announcements', as: :my_admin_announcements
    get 'my-admin/people',        as: :my_admin_people
    get 'my-admin/website',       as: :my_admin_website
    get 'my-admin/messages',      as: :my_admin_messages
    get 'my-admin/settings',      as: :my_admin_settings
  end

  controller :my_sales do
    get 'my-sales/queue',         as: :my_sales_queue
    get 'my-sales/classes',       as: :my_sales_classes
    get 'my-sales/announcements', as: :my_sales_announcements
    get 'my-sales/messages',      as: :my_sales_messages
    get 'my-sales/settings',      as: :my_sales_settings
  end

  controller :my_account do
    get 'my-account/plan',     as: :my_account_plan
    get 'my-account/messages', as: :my_account_messages
    get 'my-account/settings', as: :my_account_settings
  end

  get  'about-us'                                    => 'general#about_us'
  get  'testimonials'                                => 'general#testimonials'
  get  'consulting'                                  => 'general#consulting'
  get  'partners'                                    => 'general#partners'
  get  'labs'                                        => 'general#labs'
  get  'my-queue'                                    => 'general#my_queue'
  get  'new-search'                                  => 'general#new_search'
  get  'search'                                      => 'general#search'
  get  'contact_us'                                  => 'general#contact_us_new'
  post 'contact_us'                                  => 'general#contact_us_create'
  get  'exams/search/:query'                         => 'exams#search',                   as: :exam_search
  get  'platforms/:platform_id/group_items/selector' => 'group_items#selector',           as: :group_item_selector
  post 'roles/change_role'                           => 'roles#change_role',              as: :change_role
  post 'chosen_courses/toggle_active'                => 'chosen_courses#toggle_active',   as: :toggle_chosen_course_active
  post 'chosen_courses/toggle_attended'              => 'chosen_courses#toggle_attended', as: :toggle_chosen_course_attended
  post 'passed_exams/toggle'                         => 'passed_exams#toggle',            as: :toggle_passed_exam
  post 'request-quote'                               => 'leads#request_quote',            as: :request_quote
  get  'events-upload'                               => 'events#upload_form'
  post 'events-upload'                               => 'events#upload'
end

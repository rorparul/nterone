NterOne::Application.routes.draw do
  root to: 'general#welcome'
  devise_for :users,
             controllers: { registrations: 'users/registrations',
                            sessions: 'users/sessions',
                            invitations:   'users/invitations' }

  devise_scope :user do
    post 'users/:id/resend-invitation', as: :resend_invite, to: 'users/invitations#resend'
    get '/logout' => 'devise/sessions#destroy'
  end

  mount Forem::Engine, :at => '/forums'

  resources :users  do
    post :toggle_archived, on: :member
    collection do
      get '/users/:id/edit_from_my_queue' => 'users#edit_from_my_queue', as: :edit_from_my_queue
      get 'page'
    end
  end

  get 'admin/' => 'admin#index'

  resources :pages

  resources :articles

  resources :image_store_units

  resources :carts
  get 'cart/calculator'      => 'carts#calculator',      as: :cart_calculator
  get 'cart/render_discount' => 'carts#render_discount', as: :render_discount
  get 'admin/insights/carts' => 'insights#carts',        as: :insights_carts

  resources :discounts
  resources :order_items
  resources :orders do
    collection do
      get '/:id/confirmation' => 'orders#confirmation', as: :confirmation
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

  resources :lab_rentals, path: 'lab-reservations'
  get 'new_file' => 'lab_rentals#new_file'
  post 'upload_path' => 'lab_rentals#upload'
  get 'edit_pods/lab_rentals'     => 'lab_rentals#edit_pods',   as: :edit_pods
  post 'update_pods/lab_rentals'  => 'lab_rentals#update_pods', as: :update_pods
  post 'checkout/lab_rental'     => 'lab_rentals#self_checkout',     as: :checkout_lab_rental

  resources :companies

  resources :lab_courses do
    resources :lab_course_time_blocks
  end
  post 'time_select/lab_course_time_blocks' => 'lab_courses#time_select',            as: :time_select_lab_course_time_block

  resources :platforms, path: 'training' do
    collection do
      get  'new-vendor-import' => 'platforms#new_import'
      post 'vendor-import'     => 'platforms#import'
    end

    get 'vendor-export' => 'platforms#export'

    resources :categories, except: [:edit] do
      collection do
        get  'select'
        post 'select_to_edit'
      end
    end

    resources :subjects, path: 'certifications' do
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
      end
    end

    resources :courses, except: [:index] do
      collection do
        get  'page'
        get  'select'
        post 'select_to_edit'
        get  'courses/:id/download'      => 'courses#download',      as: :course_download
        get  'courses/:id/video_preview' => 'courses#video_preview', as: :course_video_preview
      end

      get 'clone_form', on: :member
      post 'clone', on: :member

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
        get  'play_video/:id' => 'video_on_demands#play_video', as: :play_video
        get  '/:video_id/quiz/:id' => 'video_on_demands#init_quiz', as: :init_quiz
        post '/:video_id/quiz/:id/begin' => 'video_on_demands#begin_quiz', as: :begin_quiz
        post '/:video_id/quiz/:id/next-question' => 'video_on_demands#next_quiz_question', as: :next_quiz_question
        post '/:video_id/quiz/:id/exit' => 'video_on_demands#exit_quiz', as: :exit_quiz
        get  '/:video_id/quiz/:id/scores' => 'video_on_demands#show_scores', as: :show_scores
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

  resources :videos
  resources :lms_exams

  namespace :lms do
    get '/manager',         to: 'students#index'
    get '/assign/:item_id', to: 'student_assignments#assign'

    resources :students, only: [:index, :show] do
      resources :courses,     only: [:show],                     controller: 'student_courses'
      resources :assignments, only: [:index, :create, :destroy], controller: 'student_assignments'
    end

    namespace :export do
      get 'grades'
      get 'progress'
    end

    resources :business,       only: :index
    resources :assign_manager, only: [:index, :create]
  end

  namespace :reports do
    resources :commissions,             only: [:new, :create]
    resources :profit_sheets,           only: [:new, :create]
    resources :instructor_utilizations, only: [:new, :create]
  end

  controller :admin do
    get 'admin/queue',                               as: :admin_queue
    get 'admin/orders',                              as: :admin_orders
    get 'admin/orders/:id'  => 'admin#orders_show',  as: :admin_orders_show
    get 'admin/classes',                             as: :admin_classes
    get 'admin/classes/:id' => 'admin#classes_show', as: :admin_classes_show
    get 'admin/courses',                             as: :admin_courses
    get 'admin/lab-rentals',                         as: :admin_lab_rentals, path: 'admin/lab-reservations'
    get 'admin/announcements',                       as: :admin_announcements
    get 'admin/people',                              as: :admin_people
    get 'admin/website',                             as: :admin_website
    get 'admin/messages',                            as: :admin_messages
    get 'admin/settings',                            as: :admin_settings
  end

  controller :my_account do
    get 'my-account/my-nterone' => 'my_account#plan', as: :my_account_plan
    get 'my-account/messages',                        as: :my_account_messages
    get 'my-account/settings',                        as: :my_account_settings
  end

  get  'instructor/classes'                          => 'instructors#classes',               as: :instructor_classes
  get  'instructor/classes/:id'                      => 'instructors#classes_show',          as: :instructor_classes_show
  get  'welcome'                                     => 'general#sign_up_confirmation',      as: :welcome
  get  'feed'                                        => 'events#feed'
  get  'sitemap'                                     => 'general#sitemap',                   as: :sitemap
  get  'page'                                        => 'events#page'
  get  'courses/page'                                => 'courses#page'
  get  'student-registered-classes'                  => 'events#student_registered_classes', as: :student_registered_classes
  get  'featured-classes'                            => 'general#featured_classes',          as: :featured_classes
  get  'about-us/general'                            => 'general#about_us',                  as: :about_us
  get  'about-us/executives'                         => 'general#executives',                as: :executives_bios
  get  'about-us/instructors'                        => 'general#instructors',               as: :instructors_bios
  get  'about-us/press'                              => 'general#press',                     as: :press
  get  'about-us/blog'                               => 'general#blog',                      as: :blog
  get  'about-us/industry'                           => 'general#industry',                  as: :industry
  get  'about-us/nterone_gives_back'                 => 'general#nterone_gives_back',        as: :nterone_gives_back
  get  'testimonials'                                => 'general#testimonials'
  get  'consulting'                                  => 'general#consulting'
  get  'partners'                                    => 'general#partners'
  get  'labs'                                        => 'general#labs'
  get  'my-queue'                                    => 'general#my_queue'
  get  'new-search'                                  => 'general#new_search'
  get  'search'                                      => 'general#search'
  get  'contact_us'                                  => 'general#contact_us_new',            as: :contact_us
  post 'contact_us'                                  => 'general#contact_us_create'
  get  'contact_us_confirmation'                     => 'general#contact_us_confirmation',   as: :contact_us_confirmation
  get  'exams/search/:query'                         => 'exams#search',                      as: :exam_search
  get  'platforms/:platform_id/group_items/selector' => 'group_items#selector',              as: :group_item_selector
  post 'roles/change_role'                           => 'roles#change_role',                 as: :change_role
  post 'chosen_courses/toggle_active'                => 'chosen_courses#toggle_active',      as: :toggle_chosen_course_active
  post 'chosen_courses/toggle_attended'              => 'chosen_courses#toggle_attended',    as: :toggle_chosen_course_attended
  post 'passed_exams/toggle'                         => 'passed_exams#toggle',               as: :toggle_passed_exam
  post 'request-quote'                               => 'leads#request_quote',               as: :request_quote
  get  'events-upload'                               => 'events#upload_form'
  post 'events-upload'                               => 'events#upload'
  get  '/courses/export'                             => 'courses#export',                    as: :courses_export
  get  '/events/:id/edit_in_house_note'              => 'events#edit_in_house_note',         as: :edit_in_house_note
  put  '/events/:id/update_in_house_note'            => 'events#update_in_house_note',       as: :update_in_house_note
  get  '/:company_slug/lab-reservations/new'         => 'lab_rentals#new',                   as: :new_company_lab_reservations
  get  '/:company_slug/lab-reservations/:id/edit'    => 'lab_rentals#edit',                  as: :edit_company_lab_reservations
  get  'sims/versastack'                             => 'general#sims',                      as: :sims
  get  '/nci'                                        => 'general#nci',                       as: :nci
  get  '/support'                                    => 'general#support',                   as: :support

  namespace :api do
    get '/users/:id' => 'users#show', as: :user

    namespace :v1 do
      get '/events/upcoming_public_featured_events' => 'events#upcoming_public_featured_events'
    end
  end

  # get  'hacp/test'     => 'cisco_digital_learning#hacp_test',     as: :hacp_test
  get  'cdl/:cdl_course_code' => 'cisco_digital_learning#show',     as: :cdl_show
  post 'cdl/callback'         => 'cisco_digital_learning#callback', as: :cdl_callback

  # Redirects:
  get '/training/cisco'  => redirect('/training')
  get '/training/vmware' => redirect('/training')

  # Redirects from old site:
  get '/courses/:id',                          to: redirect('/training')
  get '/certifications/:id',                   to: redirect('/training')
  get '/component/:id',                        to: redirect('/training')
  get '/training/:id',                         to: redirect('/training')
  get "/about-us/"                             => redirect("/about-us/general")
  get "/contact-us/"                           => redirect("/index")
  get "/just-in-time-training/"                => redirect("/training")
  get "/my-dashboard/"                         => redirect("/users/sign_in")
  get "/news/"                                 => redirect("/about-us/press")
  get "/nterone-gives-back/"                   => redirect("/about-us/nterone_gives_back")
  get "/our-team/executives/"                  => redirect("/about-us/executives")
  get "/our-team/instructors-and-consultants/" => redirect("/about-us/instructors")
  get "/our-team/instructor-services/"         => redirect("/about-us/instructors")
  get "/register/"                             => redirect("/users/sign_in")
  get "/terms-and-conditions/"                 => redirect("/pages/nterone-terms-and-conditions")
  get "/cisco-learning-credits/"               => redirect("/training")

  post "public/uploads/editor"                 => 'general#editor_upload_photo'
end

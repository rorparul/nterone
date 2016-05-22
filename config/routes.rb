NterOne::Application.routes.draw do
  root to: 'general#welcome'
  devise_for :users,
             controllers: { registrations: 'users/registrations',
                            sessions: 'users/sessions',
                            invitations:   'users/invitations' }

  # ActiveAdmin.routes(self)

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

  get 'cart'            => 'carts#show',       as: :cart
  get 'cart/calculator' => 'carts#calculator', as: :cart_calculator
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

  resources :platforms, path: 'training' do
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
    get '/', to: 'session#new'
    get '/manager', to: 'students#index'

    resources :students, only: [:index, :show] do
      resources :courses, only: [:show], controller: 'student_courses'
      resources :assignments, only: [:index, :create, :destroy], controller: 'student_assignments'
    end

    namespace :export do
      get 'grades'
      get 'progress'
    end

    resources :business, only: :index
  end

  controller :admin do
    get 'admin/queue',                               as: :admin_queue
    get 'admin/orders',                              as: :admin_orders
    get 'admin/orders/:id'  => 'admin#orders_show',  as: :admin_orders_show
    get 'admin/classes',                             as: :admin_classes
    get 'admin/classes/:id' => 'admin#classes_show', as: :admin_classes_show
    get 'admin/courses',                             as: :admin_courses
    get 'admin/announcements',                       as: :admin_announcements
    get 'admin/people',                              as: :admin_people
    get 'admin/website',                             as: :admin_website
    get 'admin/messages',                            as: :admin_messages
    get 'admin/settings',                            as: :admin_settings
  end

  # controller :my_sales do
  #   get 'my-sales/queue',                                  as: :my_sales_queue
  #   get 'my-sales/classes',                                as: :my_sales_classes
  #   get 'my-sales/classes/:id' => 'my_sales#classes_show', as: :my_sales_classes_show
  #   get 'my-sales/announcements',                          as: :my_sales_announcements
  #   get 'my-sales/messages',                               as: :my_sales_messages
  #   get 'my-sales/settings',                               as: :my_sales_settings
  # end

  controller :my_account do
    get 'my-account/my-nterone' => 'my_account#plan', as: :my_account_plan
    get 'my-account/messages',                        as: :my_account_messages
    get 'my-account/settings',                        as: :my_account_settings
  end

  get  'feed'                                        => 'events#feed'
  get  'sitemap'                                     => 'general#sitemap',                as: :sitemap
  get  'page'                                        => 'events#page'
  get  'courses/page'                                => 'courses#page'
  get  'featured-classes'                            => 'general#featured_classes',       as: :featured_classes
  get  'about-us/general'                            => 'general#about_us',               as: :about_us
  get  'about-us/executives'                         => 'general#executives',             as: :executives_bios
  get  'about-us/instructors'                        => 'general#instructors',            as: :instructors_bios
  get  'about-us/press'                              => 'general#press',                  as: :press
  get  'about-us/blog'                               => 'general#blog',                   as: :blog
  get  'about-us/industry'                           => 'general#industry',               as: :industry
  get  'about-us/nterone_gives_back'                 => 'general#nterone_gives_back',     as: :nterone_gives_back
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
end

![maxresdefault](https://user-images.githubusercontent.com/50967799/195754072-b8c292ca-31c1-4704-b84d-a72f6b44df09.jpg)
# UFC Bet Simulator
* This web application serves as a hub for fight fans wanting to track their betting history without the stress of gambling.
## Application Flow
### 1) Ruby on Rails
* Model-View-Controller
  * Structured around [MVC](https://developer.mozilla.org/en-US/docs/Glossary/MVC) archicture, models represent data, controllers handle/direct actions based on input/model validation, and return the appropriate view with queried data in form of an [ERB](https://github.com/ruby/erb) template.
### 2) Hotwire
* [Hotwire](https://hotwired.dev/), the default front-end framework for Rails 7 offers an easier developing experience with the help of Turbo and Stimulus.
  ### Turbo
  * The heart of Hotwire, Turbo speeds up page changes, form submissions, and partial page updates without having to write any Javascript.
  * Utilizes [Turbo Streams](https://turbo.hotwired.dev/handbook/streams) & [Turbo Frames](https://turbo.hotwired.dev/handbook/frames) for live refreshing of HTML components.
  ### Stimulus
  * For tasks outside of Turbo's reach, custom javascript is written with Stimulus alongside simple annotations on HTML elements for targeting.
### 3) Background Jobs
* Using the background job framework for Rails - [Active Job](https://edgeguides.rubyonrails.org/active_job_basics.html), time consuming tasks are created as jobs and sent to the [delayed_job](https://github.com/collectiveidea/delayed_job) queueing backend and processed when job workers are available.
* Cron Jobs are used in tandom to regularly schedule the retrieval and updating of live betting odds for upcoming fights.
### 4) Authentification
* [Devise](https://github.com/heartcombo/devise), the widely used auth package slightly customized to use usernames rather than emails.

## Deployment
### Starting Web Server
```
#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
```
### Starting Background Worker
```
rake jobs:work
```
#### Artin Mirzayans

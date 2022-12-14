# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/activestorage",
    to:
      "https://ga.jspm.io/npm:@rails/activestorage@7.0.2/app/assets/javascripts/activestorage.esm.js"
pin "@fortawesome/fontawesome-free",
    to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.1/js/all.js"

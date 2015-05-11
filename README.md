## Tolaria

Tolaria is an opinionated Rails content management system (CMS) framework. It greatly speeds up the necessary but repetitive task of creating useful admin panels, forms, and model workflows for site authors.

[![](https://cloud.githubusercontent.com/assets/769083/7573791/56eda172-f7f6-11e4-8df7-36015cf5cf85.png)](https://cloud.githubusercontent.com/assets/769083/7573791/56eda172-f7f6-11e4-8df7-36015cf5cf85.png)

[![](https://cloud.githubusercontent.com/assets/769083/7573968/cc448ebc-f7f7-11e4-8593-c6465d3a8e3c.png)](https://cloud.githubusercontent.com/assets/769083/7573968/cc448ebc-f7f7-11e4-8593-c6465d3a8e3c.png)

### Features

- Fully responsive, and we think it's beautiful too.
- Automatically builds navigation and admin routes for you.
- Automatic simple index screens and text search, which you can expand.
- Tools to provide inline help and documentation to your editors.
- Includes a handful of advanced form fields, notably a fullscreen Markdown editor and searchable select/tag lists.
- No passwords. Tolaria uses email-based authentication, and it's ready to go.
- No magic DSL. Work directly in ERB on admin forms, index views, and inspection screens.
- Completely divorced/compartmentalized from the rest of the Rails application.
- Easily overridable on a case-by-case basis for more advanced CMS functionality.
- Designed for use on Heroku and HTTPS websites.
- Modest dependencies.

### Browser Support

Tolaria supports IE10+, Safari, Chrome, Firefox, iOS, and Android 2.3+. Note that these are the browsers your site editors will need, not the general site audience, which can differ.

### Getting Started

Add Tolaria to your project's `Gemfile`, then update your bundle.

```ruby
gem "tolaria"
```

After your bundle is good, you can run an installation generator. This will create an initializer for Tolaria that you should configure, and also create a migration to set up an `administrators` table. Migrate your database.

```shell
rails generate tolaria:install
rake db:migrate
```

Review all of the settings in `config/initializers/tolaria.rb`.

Now run this Rake command to create your first administrator account:

```shell
rake admin:create
```

Tolaria needs to be able to dispatch email. You'll need to configure ActionMailer to use an appropriate mail service. Here's an example using [Mailgun on Heroku](https://devcenter.heroku.com/articles/mailgun):

```ruby
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  port: ENV.fetch("MAILGUN_SMTP_PORT"),
  address: ENV.fetch("MAILGUN_SMTP_SERVER"),
  user_name: ENV.fetch("MAILGUN_SMTP_LOGIN"),
  password: ENV.fetch("MAILGUN_SMTP_PASSWORD"),
  domain: "example.org",
  authentication: :login,
  enable_starttls_auto: true,
}
```

Start your Rails server and go to `/admin` to log in.

### Contributing

Tolaria is provided free of charge, under the MIT license. If it works great for your project, [we'd love to hear about it](http://twitter.com/threespot)!

Threespot has limited capacity to provide support or assess pull requests for Tolaria. We'll change and update Tolaria for our purposes, but for now, we do not accept issues or contributions. Our apologies!

### Miscellaneous Technical Details

- The constant and module name `Admin` is reserved for Tolaria's use.
- The route space `/admin/**/*` is reserved for Tolaria's use.

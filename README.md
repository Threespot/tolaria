## Tolaria

Tolaria is a [content management system](https://en.wikipedia.org/wiki/Content_management_system) (CMS) framework for [Ruby on Rails](https://en.wikipedia.org/wiki/Ruby_on_Rails). It greatly speeds up the necessary (but repetitive) task of creating useful admin panels, forms, and model workflows for site authors.

[![](https://cloud.githubusercontent.com/assets/769083/7573791/56eda172-f7f6-11e4-8df7-36015cf5cf85.png)](https://cloud.githubusercontent.com/assets/769083/7573791/56eda172-f7f6-11e4-8df7-36015cf5cf85.png)

[![](https://cloud.githubusercontent.com/assets/769083/7573968/cc448ebc-f7f7-11e4-8593-c6465d3a8e3c.png)](https://cloud.githubusercontent.com/assets/769083/7573968/cc448ebc-f7f7-11e4-8593-c6465d3a8e3c.png)

### Features

- Fully responsive (and we think it's beautiful too!)
- Automatically builds navigation and admin routes for you.
- Automatically creates simple index screens, show screens, and text search tools, which you can expand.
- Includes a handful of advanced form fields, notably a fullscreen Markdown editor and searchable select/tag lists.
- Assists in providing inline help and documentation to your editors.
  No passwords to manage! Tolaria uses email-based authentication.
- No magic DSL. Work directly in ERB on admin forms, index views, and inspection screens.
- Completely divorced/compartmentalized from the rest of the Rails application.
- Easily overridable on a case-by-case basis for more advanced CMS functionality.
- Designed for use on Heroku, in containers, and on websites with TLS.
- Modest dependencies.

### Browser Support

Tolaria supports IE10+, Safari, Chrome, Firefox, iOS, and Android 2.3+. Note that these are the browsers your site editors will need, not the general site audience, which can differ.

### Getting Started

Add Tolaria to your project's `Gemfile`:

```ruby
gem "tolaria"
```

Then update your bundle.

Now run the installation generator. This will create an initializer for Tolaria plus a migration to set up an `administrators` table. Migrate your database.

```shell
$ rails generate tolaria:install
$ rake db:migrate
```

Review all of the settings in `config/initializers/tolaria.rb`.

Run this Rake command to create your first administrator account:

```shell
$ rake admin:create
```

Tolaria needs to be able to dispatch email. You'll need to configure ActionMailer to use an appropriate mail service. Here's an example using [Mailgun on Heroku](https://devcenter.heroku.com/articles/mailgun):

```ruby
# config/initializers/action_mailer.rb

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

Now start your Rails server and go to `/admin` to log in!

### Adding Administrator Accounts

You can add administrators from the command line using a Rake task. This is particularly useful for creating the very first one.

```shell
$ rake admin:create
```

If you are already logged in to Tolaria, you can also simply visit `/admin/administrators` to create a new account using the CMS interface.

### Managing a Model

Inside your ActiveRecord definition for your model, call `manage_with_tolaria`, passing configuration in the `using` Hash. [Refer to the documentation for all of the options](#FIXME).

**Important:** you'll need to provide the options to pass to `params.permit` here for the admin system. Your form won't work without it!

```ruby
class BlogPost < ActiveRecord::Base
  manage_with_tolaria using: {
    icon: "file-o",
    category: "Settings",
    priority: 5,
    permit_params: [
      :title,
      :body,
      :author_id,
    ]
  }
end
```

### Customizing Indexes

By default, Tolaria will build a simple index screen for each model. You'll likely want to replace it for complicated models, or to allow administrators to sort the columns.

If your model was `BlogPost`, you'll need to create a file in your project at: `app/views/admin/blog_posts/_index.html.erb`.

See the [TableHelper documentation](#FIXME) for more information.

```erb
<% # app/views/admin/blog_posts/_index.html.erb %>

<%= index_table do %>
  <thead>
    <tr>
      <%= index_th :id %>
      <%= index_th :title %>
      <%= index_th "Author", sortable: false %>
      <%= actions_th %>
    </tr>
  </thead>
  <tbody>
    <% @resources.each do |blog_post| %>
      <tr>
        <%= index_td blog_post, :id %>
        <%= index_td blog_post, :title %>
        <%= index_td blog_post, blog_post.author.name, image:blog_post.author.portrait_uri %>
        <%= actions_td blog_post %>
      </tr>
    <% end %>
  </tbody>
<% end %>
```

### Customizing The Inspect Screen

Tolaria provides a very basic show/inspect screen for models. You'll want to provide your own for complex models.

If your model was `BlogPost`, you'll need to create a file in your project at: `app/views/admin/blog_posts/_show.html.erb`.

See the [TableHelper documentation](#FIXME) for more information.

```erb
<% # app/views/admin/blog_posts/_show.html.erb %>

<%= show_table do %>

  <thead>
    <%= show_thead_tr %>
  </thead>
  <tbody>
    <%= show_tr :title %>
    <%= show_tr "Author", @resource.author.name %>
    <%= show_tr :body %>
  </tbody>

<% end %>
```

### Adding Model Forms

Tolaria does not build editing forms for you, but it attempts to help speed up your work by providing a wrapper.

If your model was `BlogPost`, you'll need to create a file in your project at  `app/views/admin/blog_posts/_form.html.erb`. You'll provide the form code that would appear inside the `form_for` block, excluding the submit buttons. The builder variable is `f`.

```erb
<% # app/views/admin/blog_posts/_form.html.erb %>

<%= f.label :title %>
<%= f.text_field :title, placeholder:"Post title" %>
<%= f.hint "The title of this post. A good title is both summarizing and enticing, much like a newspaper headline."

<%= f.label :author_id, "Author" %>
<%= f.searchable_select :author_id, Author.all, :id, :name, include_blank:false %>
<%= f.hint "Select the person who wrote this post."

<%= f.label :body %>
<%= f.markdown_composer :body %>
<%= f.hint "The body of this post. You can use Markdown!"
```

### Customizing The Search Form

By default, Tolaria provides a single search field that searches over all of the text or character columns of a model. You can expand the search tool to include other facets.

**Important:** This system uses the [Ransack gem][ransack], which you'll need to familiarize yourself with.

If your model was `BlogPost`, you'll need to create a file in your project at  `app/views/admin/blog_posts/_search.html.erb`. You'll provide the form code that would appear inside the `search_form_for` block, excluding the submit buttons. The builder variable is `f`.

```erb
<% # app/views/admin/blog_posts/_search.html.erb %>

<%= f.label :title_cont, "Title contains" %>
<%= f.search_field :title_cont, placeholder:"Anything" %>

<%= f.label :author_name_cont, "Author is" %>
<%= f.searchable_select :author_name_cont, Author.all, :name, :name, prompt:"Any author" %>

<%= f.label :body_cont, "Body contains" %>
<%= f.search_field :body_cont, placeholder:"Anything" %>
```

[ransack]: https://github.com/activerecord-hackery/ransack

### Provided Form Fields

You can use all of the Rails-provided fields on your forms, but Tolaria also comes with a set of advanced, JavaScript-backed fields. Make sure to [review the documentation for the form builder](#FIXME) to get all the details.

##### Markdown Composer

The markdown_composer helper will generate a very fancy Markdown editor, which includes text snippet tools and a fullscreen mode with live previewing.

**Important:** You cannot use this field properly if you do not set up `Tolaria.config.markdown_renderer`. Without it, the live preview will only use `simple_format`!

##### Searchable Select

The searchable_select helper displays out a [Chosen select field][chosen] that authors can filter by typing.

[chosen]: http://harvesthq.github.io/chosen/

##### Timestamp Field

The timestamp_field helper displays a text field that validates a provided timestamp and recovers to a template if blanked.

##### Slug Field

The slug_field helper allows you to show the parameterized value of a field in a given pattern preview.

##### Color Field

The color_field helper validates and displays a given hexadecimal color.

##### Image Field

The image_field helper displays a button that makes uploading an image a little more pleasant than a regular `file_field`.

##### Attachment Field

The attachment_field helper displays a button that makes uploading an arbirary file a little more pleasant than a regular `file_field`.

##### Hints

Inline help is useful for reminding administrators about what should be provided for each field. Use `f.hint` to present a hint for a field.

### Customizing the Menu

When you call `manage_with_tolaria`, you can provide a category and a priority like below. Items in the same category will be grouped together in the navigation menu. Items are sorted priority ascending in their group.

```ruby
class BlogPost < ActiveRecord::Base
  manage_with_tolaria using:{
    category: "Prose",
    priority: 5,
  }
end
```

If you want to re-order the groups, you need to set an array of menu titles ahead of time in `Tolaria.config.menu_categories`:

```ruby
# config/initializers/tolaria.rb
Tolaria.configure do |config|
  config.menu_categories = [
    "Prose",
    "Animals",
    "Settings",
  ]
end
```

### Patching a Controller

Tolaria dynamically creates controllers for managed models, named as you would expect. If you want to replace or add to controller functionality, create the file in your parent application and patch away:

If your model was `BlogPost`, you should create `app/controllers/admin/blog_posts_controller.rb`

```ruby
# app/controllers/admin/blog_posts_controller.rb
class Admin::BlogPostsController < TolariaController
  def another_method
     # do stuff
     # render a template
  end
end
```

You might want to [check out what we've done in the base ResourceController](https://github.com/Threespot/tolaria/blob/master/lib/tolaria/controllers/resource_controller.rb) file so that you know what you're patching. If you override any of the existing methods, you're on your own to handle everything correctly.

### Adding Your Own Styles or JavaScript

If you want to add additional Sass or JavaScript to the admin system, you can create these files and then append to them as you need. Make sure that you import the base styles and JavaScript so you inherit what's already been done.

`app/assets/stylesheets/admin/admin.scss`:

```sass
@import "admin/base";
// Your code goes here
```

`app/assets/javascripts/admin/admin.js`:

```javascript
//= require admin/base
// Your code goes here
```

### Miscellaneous Technical Details

- The constant and module name `Admin` is reserved for Tolaria's use.
- The route space `/admin/**/*` is reserved for Tolaria's use. If you add routes here, be sure you are not colliding with a Tolaria-generated route.

### License and Contributing

Tolaria is free software, and may be redistributed under the terms of the [MIT license](https://github.com/Threespot/tolaria/blob/master/LICENSE). If Tolaria works great for your project, [we'd love to hear about it](http://twitter.com/threespot)!

Threespot has limited capacity to provide support or assess pull requests for Tolaria. We'll change and update Tolaria for our purposes, but for now, we do not accept issues or contributions. Our apologies!

### Thanks

Our work stands on the shoulders of giants, and we're very thankful to the many people that made Tolaria possible either by publishing code we used, or by being an inspiration for this project.

- [The ActiveAdmin team](https://github.com/activeadmin/activeadmin/graphs/contributors)
- [The jQuery Foundation](https://jquery.org)
- [Jeremy Ashkenas](https://twitter.com/jashkenas)
- [The Harvest Team](https://www.getharvest.com/about/meet-the-team)

### About Threespot

Threespot is a design and development agency from Washington, DC. We work for organizations that we believe are making a positive change in the world. Find out more [about us](https://www.threespot.com), [our projects](https://www.threespot.com/work) or [hire us](https://www.threespot.com/agency/hire-us)!

[![](https://avatars3.githubusercontent.com/u/370822?v=3&s=100)](https://www.threespot.com)

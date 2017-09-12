### Usage

- To run rails app (here demo_rails contains the rails application) do :

```
rake run_app:rails

```

- To `bundle install` in a folder(e.g. demo_rails) :

```
rake run_app:bundle_install['demo_rails']

```

- To `bundle update` in a folder(e.g. demo_rails) :

```
rake run_app:bundle_update['demo_rails']

```

- To `bundle exec rails s` in a folder(e.g. demo_rails) :

```
rake run_app:rails_server['demo_rails']

```

**Note:** Actually `rake run_app:rails`calls the `bundle_install`,
`bundle_update`,`rails_server` .

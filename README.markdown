                    _____     __
                   / ___/___ / /_  __ _____ __ ______
                  / (_ // -_) __/ / // / _ | // / __/
                  \___/ \__/\__/  \_, /\___|_,_/_/
          '-(+++++...            /___/ ............  s++++++++.
       .(++++++++++++(      -+++~~~~~  'N++++++++++= B++++++++s
      '+++++++++++++++(     DN=++++++< -NB+++++++++s Bz++++++++
      +++++++++++++++++.   'NNN=++++++(-BNB+++++++++'BN========-
     =B=+++++++++sDBBBBs<. +NNNN=+++++(<NNNBDBDBNNNNDBNNBBBBBBBz
    'NN+s+++++=BBBh=+((+sB=DNNNNNBBBNNDhNNNN'   ..  -BNs      (z
    sN+N+z+++sBs-        .hNNNNBNh(-'   NNNN.  .NB-  <Ns   +BBBz
    D+N+N+z=Bs.   .~.     'NNNNNB~      DNNN   .NN+  (Ns   =B+~
    BN+N+NNB+    ~NBD      BNNNBN   h'  hNNN   .Bs<  <Ns   =Dz~
    BNNNN+ND     +BhB      DNNNBz  'N~  sNNN   'ND'  hNs    -(z-
    NNNNNNB(     sDDN      hNNNB(  +N~  +NNN    ..-<hBNs    ~=h-
    NNNNNNB-     sDBN     'DNNNN.  DN~  <BNN   'NNhs(NNs   =NN-
    NNNNNNB'     zNNN(+sDNNBNNNz  .NB(  ~BNN   'D    NNs   =Bh~
    NNNNNNN.     zNNNBNBBNNNNNB(  <NB~  'BNB   'D    <Bs   =NNNN
    NNNNNNN.     zNNNNNNNNNNBNN.  .     .NDB   -D     hs       N
    NNNNNNN.     zNNNNNhBNBN=+z   +BN-   NDB  '(D     <BhhhhhhhN
    BNNNNNN.     zNNNh=<~. h-s<   D~D'.-~B<NBNBDs     ''``
    DNNNNNN.     zNNN      D-B-~(+B DNBDzs-`
    sNNNNNN.     zNNN      B(NDhs=(  ''`
    (BNNNNN'     zNDB     ~D.
     sNNNNB-     +hsz     h<                             O___
      <NNNB(     -=s'   'hz      ___  ___              < s > \____
        ~BNh          .+B+      / _ \/ _ \               = \    /
          ~Dz~.   .~+zB='       \___/_//_/              / \ \__/
            <hNNBNBh=(.                                /   \   `
               ..

# Cape

[![Travis CI build status]](http://travis-ci.org/njonsson/cape          "Travis CI build status")
[![Gemnasium build status]](http://gemnasium.com/njonsson/cape          "Gemnasium build status")
[![Code Climate report]   ](http://codeclimate.com/github/njonsson/cape "Code Climate report")
[![Inline docs]           ](http://inch-pages.github.io/github/njonsson/cape "Inline docs")
[![RubyGems release]      ](http://rubygems.org/gems/cape               "RubyGems release")

If

* **You use [Capistrano](http://capistranorb.com)** to deploy your application, and
* **You have [Rake](http://rake.rubyforge.org) tasks that you want to execute remotely** — but you don’t want to hand-code Capistrano recipes for each Rake task —

Then

* **You can use the [Cape](http://njonsson.github.io/cape) DSL** within Capistrano recipes to dynamically add recipes for your application’s Rake tasks, and
* **You can execute your Rake tasks on your deployed servers,** friction-free, and look like a superhero. _[cue fanfare]_

## Features

* **Mirror Rake tasks** as Capistrano recipes, optionally filtered by namespace or name
* **Embed Rake tasks** in Capistrano namespaces
* **Pass arguments** to Rake tasks by setting environment variables with the same names
* **Specify the Rake executable** for local and remote Rake installations
* **Enumerate Rake tasks** for your own purposes

See what’s changed lately by reading the [project history](http://github.com/njonsson/cape/blob/master/History.markdown).

## Installation — get your Cape on

Install [the RubyGem](http://rubygems.org/gems/cape "Cape at RubyGems.org").

    $ gem install cape

Or you may want to make Cape a dependency of your project by using [Bundler](http://gembundler.com).

    # Gemfile

    source 'http://rubygems.org'

    gem 'cape', '~> 1'

## Compatibility

Cape [runs](http://travis-ci.org/njonsson/cape) on the following Ruby versions:

* MRI v1.8.7, v1.9.2, v1.9.3, v2.0.0
* REE v1.8.7

Cape integrates with the following RubyGems:

* Capistrano v2.x
* Rake v0.8.7 and later

**A Rake task that lacks a description can be mirrored or enumerated only if Rake v0.9.3 or newer is installed.** Older versions of Rake did not support enumerating such tasks. You may want to make Rake v0.9.3 a dependency of your project.

    # Gemfile

    source 'http://rubygems.org'

    gem 'rake', '>= 0.9.3'

## Examples

Assume the following Rake tasks are defined.

    desc 'Rakes the leaves'
    task :leaves do
      $stdout.puts "Raking the leaves"
    end

    desc 'Rakes and bags the leaves'
    task :bag_leaves, [:paper_or_plastic] => :leaves do |task, arguments|
      $stdout.puts "Putting the leaves in a #{arguments[:paper_or_plastic]} bag"
    end

Rake lists these tasks in the expected fashion.

    $ rake --tasks
    rake bag_leaves[paper_or_plastic]  # Rakes and bags the leaves
    rake leaves                        # Rakes the leaves

    $ rake --describe bag_leaves
    rake bag_leaves[paper_or_plastic]
        Rakes and bags the leaves

### Simply mirror all Rake tasks as Capistrano recipes

Add the following to your Capistrano recipes. Note that Cape statements must be contained in a `Cape` block.

    # config/deploy.rb

    require 'cape'

    Cape do
      # Create Capistrano recipes for all Rake tasks.
      mirror_rake_tasks
    end

Now all your Rake tasks appear alongside your Capistrano recipes.

    $ cap --tasks
    cap deploy               # Deploys your project.
    ...
    [other built-in Capistrano recipes]
    ...
    cap bag_leaves           # Rakes and bags the leaves.
    cap leaves               # Rakes the leaves.
    Some tasks were not listed, either because they have no description,
    or because they are only used internally by other tasks. To see all
    tasks, type `cap -vT'.

    Extended help may be available for these tasks.
    Type `cap -e taskname' to view it.

Let’s use Capistrano to view the unabbreviated description of a Rake task recipe, including instructions for how to pass arguments to it. Note that Rake task parameters are automatically converted to environment variables.

    $ cap --explain bag_leaves
    ------------------------------------------------------------
    cap bag_leaves
    ------------------------------------------------------------
    Bags the leaves.

    Set environment variable PAPER_OR_PLASTIC if you want to pass a Rake task argument.

Here’s how to invoke a task/recipe with arguments. On the local computer, via Rake:

    $ rake bag_leaves[plastic]
    (in /current/working/directory)
    Raking the leaves
    Putting the leaves in a plastic bag

On remote computers, via Capistrano:

    $ cap bag_leaves PAPER_OR_PLASTIC=plastic
      * executing `bag_leaves'
      * executing "cd /path/to/currently/deployed/version/of/your/app && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake bag_leaves[plastic]"
        servers: ["your.server.name"]
        [your.server.name] executing command
     ** [out :: your.server.name] (in /path/to/currently/deployed/version/of/your/app)
     ** [out :: your.server.name] Raking the leaves
     ** [out :: your.server.name] Putting the leaves in a plastic bag
        command finished in 1000ms

### Mirror some Rake tasks, but not others

Cape lets you filter the Rake tasks to be mirrored. Note that Cape statements must be contained in a `Cape` block.

    # config/deploy.rb

    require 'cape'

    Cape do
      # Create Capistrano recipes for the Rake task 'foo' and/or for the tasks in
      # the 'foo' namespace.
      mirror_rake_tasks :foo
    end

### Mirror Rake tasks that require renaming, Capistrano recipe options, path switching, and/or environment variables

Cape lets you customize mirrored Rake tasks to suit your needs. Note that Cape statements must be contained in a `Cape` block, and references to Capistrano variables such as `rails_env` and `release_path` must be contained in an inner block, lambda, or other callable object.

    # config/deploy.rb

    require 'cape'

    Cape do
      # Display defined Rails routes on application server remote machines only.
      mirror_rake_tasks :routes do |recipes|
        recipes.options[:roles] = :app
      end

      # Execute database migration on application server remote machines only,
      # and set the 'RAILS_ENV' environment variable to the value of the
      # Capistrano variable 'rails_env'.
      mirror_rake_tasks 'db:migrate' do |recipes|
        recipes.options[:roles] = :app
        recipes.env['RAILS_ENV'] = lambda { rails_env }
      end

      # Support a Rake task that must be run on application server remote
      # machines only, and in the remote directory 'release_path' instead of the
      # default, 'current_path'.
      before 'deploy:symlink', :spec
      mirror_rake_tasks :spec do |recipes|
        recipes.cd { release_path }
        recipes.options[:roles] = :app
      end

      # Avoid collisions with the existing Ruby method #test, run tests on
      # application server remote machines only, and set the 'RAILS_ENV'
      # environment variable to the value of the Capistrano variable
      # 'rails_env'.
      mirror_rake_tasks :test do |recipes|
        recipes.rename do |rake_task_name|
          "#{rake_task_name}_task"
        end
        recipes.options[:roles] = :app
        recipes.env['RAILS_ENV'] = lambda { rails_env }
      end
    end

The above is equivalent to the following manually-defined Capistrano recipes.

    # config/deploy.rb

    # These translations to Capistrano are just for illustration.

    RAKE = '/usr/bin/env '                                +
           '`'                                            +
            '/usr/bin/env bundle check >/dev/null 2>&1; ' +
            'case $? in '                                 +
               # Exit code 0: bundle is defined and installed
               # Exit code 1: bundle is defined but not installed
              '0|1 ) '                                    +
                'echo bundle exec '                       +
                ';; '                                     +
            'esac'                                        +
           '` '                                           +
           'rake'

    task :routes, :roles => :app do
      run "cd #{current_path} && #{RAKE} routes"
    end

    namespace :db do
      task :migrate, :roles => :app do
        run "cd #{current_path} && #{RAKE} db:migrate RAILS_ENV=#{rails_env}"
      end
    end

    before 'deploy:symlink', :spec
    task :spec, :roles => :app do
      run "cd #{release_path} && #{RAKE} routes"
    end

    task :test_task, :roles => :app do
      run "cd #{current_path} && #{RAKE} test RAILS_ENV=#{rails_env}"
    end

### Mirror Rake tasks into a Capistrano namespace

Cape plays friendly with the Capistrano DSL for organizing Rake tasks in Capistrano namespaces. Note that Cape statements must be contained in a `Cape` block.

    # config/deploy.rb

    require 'cape'

    namespace :rake_tasks do
      # Use an argument with the Cape block, if you want to or need to.
      Cape do |cape|
        cape.mirror_rake_tasks
      end
    end

### Iterate over available Rake tasks

Cape lets you enumerate Rake tasks, optionally filtering them by task name or namespace. Note that Cape statements must be contained in a `Cape` block.

    # config/deploy.rb

    require 'cape'

    Cape do
      # Enumerate all Rake tasks.
      each_rake_task do |t|
        # Do something interesting with this hash:
        # * t[:name] -- the full name of the task
        # * t[:parameters] -- the names of task arguments
        # * t[:description] -- documentation on the task, including parameters
      end

      # Enumerate the Rake task 'foo' and/or the tasks in the 'foo' namespace.
      each_rake_task 'foo' do |t|
        # ...
      end
    end

### Configure Rake execution

Cape lets you specify how Rake should be run on the local computer and on remote computers. But the default behavior is most likely just right for your needs:

* It detects whether Bundler is installed on the computer
* It detects whether the project uses Bundler to manage its dependencies
* It runs Rake via Bundler if the above conditions are true; otherwise, it runs Rake directly

Note that Cape statements must be contained in a `Cape` block.

    # config/deploy.rb

    require 'cape'

    # Configure Cape never to run Rake via Bundler, neither locally nor remotely.
    Cape.local_rake_executable  = '/usr/bin/env rake'
    Cape.remote_rake_executable = '/usr/bin/env rake'

    Cape do
      # Create Capistrano recipes for all Rake tasks.
      mirror_rake_tasks
    end

## Contributing

Report defects and feature requests on [GitHub Issues](http://github.com/njonsson/cape/issues).

Your patches are welcome, and you will receive attribution here for good stuff.

## License

Released under the [MIT License](http://github.com/njonsson/cape/blob/master/License.markdown).

[Travis CI build status]: https://secure.travis-ci.org/njonsson/cape.png?branch=master
[Gemnasium build status]: https://gemnasium.com/njonsson/cape.png
[Code Climate report]:    https://codeclimate.com/github/njonsson/cape.png
[Inline docs]:            http://inch-pages.github.io/github/njonsson/cape.png
[RubyGems release]:       https://badge.fury.io/rb/cape.png

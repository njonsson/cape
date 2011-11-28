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

Cape
====

If

* **You use [Capistrano](http://capify.org)** to deploy your application, and
* **You have [Rake](http://rake.rubyforge.org) tasks you want to run remotely** — but you don’t want to hand-code Capistrano recipes for each Rake task —

Then

* **You can invoke [Cape](http://github.com/njonsson/cape)** to dynamically add Capistrano recipes for each of your application’s Rake tasks, and
* **You can run your Rake tasks on your deployed servers,** friction-free, and look like a superhero. _[cue fanfare]_

Installation
------------

Install [the RubyGem](http://rubygems.org/gems/cape "Cape at RubyGems.org"):

    $ gem install cape

Or you may want to make Cape a dependency of your project by using [Bundler](http://gembundler.com).

Features
--------

* **Mirror Rake tasks** as Capistrano recipes, optionally filtered by namespace or name
* **Embed Rake tasks** in a Capistrano namespace
* **Pass arguments** to Rake tasks by setting environment variables with the same names
* **Override the default executables** for local and remote Rake installations (`/usr/bin/env rake` is the default)
* **Enumerate Rake tasks** for your own purposes

Examples
--------

Assume we have the following _Rakefile_.

    desc 'Rakes the leaves'
    task :leaves do
      # (Raking action goes here.)
    end

    desc 'Rakes and bags the leaves'
    task :bag_leaves, [:paper_or_plastic] => :leaves do
      # (Bagging action goes here.)
    end

Rake lists these tasks in the expected fashion.

    $ rake --tasks
    rake bag_leaves[paper_or_plastic]  # Rakes and bags the leaves
    rake leaves                        # Rakes the leaves

Put the following in your _config/deploy.rb_. **Note that Cape statements must be executed within a `Cape` block.**

    require 'cape'

    Cape do
      # Create Capistrano recipes for all Rake tasks.
      mirror_rake_tasks
    end

Now all your Rake tasks can be invoked as Capistrano recipes. Capistrano lists the recipes in the following fashion.

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

    You must set environment variable PAPER_OR_PLASTIC.

Cape lets you filter the Rake tasks to be mirrored:

    Cape do
      # Create Capistrano recipes for the Rake task 'foo' or for the tasks in a
      # 'foo' namespace.
      mirror_rake_tasks :foo

      # Create Capistrano recipes only for the Rake task 'bar:baz' or for the
      # tasks in the 'bar:baz' namespace.
      mirror_rake_tasks 'bar:baz'
    end

Cape plays friendly with the Capistrano DSL for organizing Rake tasks in Capistrano namespaces.

    # Use an argument with the Cape block, if you want to or need to.
    namespace :rake_tasks do
      Cape do |cape|
        cape.mirror_rake_tasks
      end
    end

Cape lets you enumerate Rake tasks, optionally filtering them by task name or namespace.

    Cape do
      each_rake_task do |t|
        # Do something interesting with this hash:
        # * t[:name] -- the full name of the task
        # * t[:parameters] -- the names of task arguments
        # * t[:description] -- documentation on the task, including parameters
      end
    end

Limitations
-----------

For now, only Rake tasks that have descriptions can be mirrored or enumerated.

Contributing
------------

Report defects and feature requests on [GitHub Issues](http://github.com/njonsson/cape/issues).

Your patches are welcome, and you will receive attribution here for good stuff.

License
-------

Released under the [MIT License](http://github.com/njonsson/cape/blob/master/MIT-LICENSE.markdown).

Given 'a full-featured Rakefile' do
  step 'a file named "Rakefile" with:', <<-end_step
    desc 'Ends with period.'
    task :with_period

    desc 'Ends without period'
    task :without_period

    desc 'My long task -- it has a very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long description'
    task :long

    desc 'My task with one argument'
    task :with_one_arg, [:the_arg]

    namespace :my_namespace do
      desc 'My task in a namespace'
      task :in_a_namespace

      namespace :my_nested_namespace do
        desc 'My task in a nested namespace'
        task :in_a_nested_namespace
      end
    end

    desc 'My task with two arguments'
    task :with_two_args, [:my_arg1, :my_arg2]

    desc 'My task with three arguments'
    task :with_three_args, [:an_arg1, :an_arg2, :an_arg3]

    task :hidden_task
  end_step
end

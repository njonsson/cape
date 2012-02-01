# Version history for the _Cape_ project

## <a name="v1.2.0"></a>v1.2.0, Wed 2/01/2012

* Add support in the DSL for specifying remote environment variables and Capistrano recipe options
* Add support for Rake tasks that overlap with (have the same full name as) namespaces
* Match Rake tasks properly: by the full name of the task rather than a substring thereof
* Don’t choke on unexpected output from Rake
* Silence Rake stderr output while enumerating Rake tasks
* Tweak the wording of generated Capistrano recipe descriptions
* Tighten RubyGem dependency specifications in an effort to avoid potential compatibility issues

## <a name="v1.1.0"></a>v1.1.0, Thu 12/29/2011

* Allow environment variables for Rake task arguments to be optional

## <a name="v1.0.3"></a>v1.0.3, Thu 12/29/2011

* Run Cucumber features from `gem test cape`

## <a name="v1.0.2"></a>v1.0.2, Thu 12/29/2011

* Support Rake task arguments that contain whitespace

## <a name="v1.0.1"></a>v1.0.1, Tue 11/29/2011

* Don’t run Cucumber features from `gem test cape` because they fail

## <a name="v1.0.0"></a>v1.0.0, Mon 11/28/2011

(First release)

require 'bundler/gem_tasks'
require 'rake/testtask'

# Rake::TestTask.new do |t|
#    t.libs << 'test'
#    t.test_files = FileList[
#       'test/writers/iso19115-2/tc*.rb'
#    ]
#    t.verbose = true
# end

Rake::TestTask.new do |t|
   t.libs << 'test'
   t.test_files = FileList[
      'test/internal/*.rb',
      'test/readers/fgdc/tc*.rb',
      'test/readers/iso19115_2/tc*.rb',
      'test/readers/iso19115_2_datagov/tc*.rb',
      'test/readers/iso19115_3/tc*.rb',
      'test/readers/mdJson/tc*.rb',
      'test/readers/sbJson/tc*.rb',
      'test/writers/fgdc/tc*.rb',
      'test/writers/html/tc*.rb',
      'test/writers/iso19110/tc*.rb',
      'test/writers/iso19115-2/tc*.rb',
      'test/writers/iso19115-3/tc*.rb',
      'test/writers/mdJson/tc*.rb',
      'test/writers/sbJson/tc*.rb',
      'test/writers/dcat_us/tc*.rb',
      'test/translator/tc*.rb'
   ]
   t.verbose = true
   t.warning = false
end

desc 'Run tests'
task default: :test

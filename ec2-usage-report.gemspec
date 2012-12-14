Gem::Specification.new do |spec|
  spec.name              = 'ec2-usage-report'
  spec.version           = '0.1.0'
  spec.summary           = 'ec2-usage-report is a library for acquiring usage report of EC2.'
  spec.require_paths     = %w(lib)
  spec.files             = %w(README) + Dir.glob('lib/**/*')
  spec.author            = 'winebarrel'
  spec.email             = 'sgwr_dts@yahoo.co.jp'
  spec.homepage          = 'https://bitbucket.org/winebarrel/ec2-usage-report'
  spec.add_dependency('mechanize')
end

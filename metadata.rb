name 'cens-web'
maintainer 'Steve Nolen'
maintainer_email 'technolengy@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures cens-web'
long_description 'Installs/Configures cens-web'
version '0.0.13'

%w(ubuntu).each do |os|
  supports os
end

depends 'nginx', '~>2.7.6'
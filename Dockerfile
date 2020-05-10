FROM tdiary/blogkit:latest
LABEL maintainer "@tdtds <t@tdtds.jp>"

WORKDIR /usr/src/app
RUN echo 'gem "tdiary-io-mongodb"' >> Gemfile.local; \
    echo 'gem "omniauth"' >> Gemfile.local; \
    echo 'gem "omniauth-twitter"' >> Gemfile.local; \
    echo 'gem "dalli"' >> Gemfile.local; \
    echo 'gem "memcachier"' >> Gemfile.local; \
    bundle --path=vendor/bundle --without=development:test --jobs=4 --retry=3; \
    sed -i "s/@data_path.*$/require 'tempfile'\n@data_path = Dir.tmpdir/" tdiary.conf; \
    sed -i "s/@style.*$/@style = 'BlogWiki'\n\n@io_class = TDiary::IO::MongoDB\n@database_url = ENV['MONGODB_URI'] || ENV['MONGOLAB_URI']\n@logger = Logger.new(\$stderr)/" tdiary.conf
COPY ["theme/tdiaryorg/", "theme/tdiaryorg/"]
COPY ["tdiary.conf", "tdiary.conf"]
COPY ["misc/plugin/", "misc/plugin/"]
COPY ["js/", "js/"]
COPY ["robots.txt", "public/robots.txt"]
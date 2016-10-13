Web site of Minsk Hackerspace - http://hackerspace.by/ 

Документация в Wiki: https://github.com/minsk-hackerspace/hackerspace.by/wiki

Новички могут посоздавать [issues] (https://github.com/minsk-hackerspace/hackerspace.by/issues), а для прокачанных, как обычно, git и pull-request'ы.

Для разработки нужен [Ruby версии 2.3 и выше](https://www.ruby-lang.org/en/installation/), а также `bundler` (http://bundler.io/).

Как запустить локальную копию сайта:

```
git clone https://github.com/minsk-hackerspace/hackerspace.by
cd hackerspace.by
bundle install
bundle exec rails db:setup
bundle exec rails server
```

`bundler` устанавливает библиотеки глобально, поэтому если не хочется мусорить, стоит посмотреть на RVM.

После старта сайт будет доступен на [http://localhost:3000/](http://localhost:3000/). Пользователь developer@hackerspace.by, пароль '111111'.

Документация в Wiki: https://github.com/minsk-hackerspace/hackerspace.by/wiki

Сайт работает на RoR (Ruby on Rails) под nginx. Текущая конфигурация сервера складируется в `infra/`.

Для запуска нужен [Ruby версии 2.3 и выше](https://www.ruby-lang.org/en/installation/), а также `bundler` (http://bundler.io/).

```
git clone https://github.com/minsk-hackerspace/hackerspace.by
cd hackerspace.by
bundle install
bundle exec rails db:setup
bundle exec rails server
```

`bundler` устанавливает библиотеки глобально, поэтому если не хочется мусорить, стоит посмотреть на RVM.

После старта сайт будет доступен на [http://localhost:3000/](http://localhost:3000/). Пользователь developer@hackerspace.by, пароль '111111'.

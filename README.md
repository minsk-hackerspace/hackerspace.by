Проект сайта [минского хакерспейса] (http://hackerspace.by).

Это основной Git-репозиторий: https://github.com/minsk-hackerspace/hspace

Wiki: https://github.com/minsk-hackerspace/hspace/wiki

Изменения можно предлагать через [issues] (https://github.com/minsk-hackerspace/hspace/issues), или, если вы владеете Git (а им стоит овладеть!), просто присылайте pull-request.

Для разработки вам понадобится иметь установленный интерпретатор Ruby (версии 1.9 и выше, см. https://www.ruby-lang.org/en/installation/) и bundler (http://bundler.io/).

Как запустить локальную копию сайта:

```
git clone https://github.com/minsk-hackerspace/hspace
cd hspace
bundle install
bundle exec rake db:setup
bundle exec rails server
```

Дождаться старта сервера, после чего идти на http://localhost:3000/. По умолчанию создаётся пользователь developer@hackerspace.by с паролем '111111'.

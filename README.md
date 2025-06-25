[![Travis Build Status](https://img.shields.io/travis/minsk-hackerspace/hackerspace.by/master)](https://travis-ci.org/minsk-hackerspace/hackerspace.by)
[![codecov](https://codecov.io/gh/minsk-hackerspace/hackerspace.by/branch/master/graph/badge.svg?token=OCuDxYFoJi)](https://codecov.io/gh/minsk-hackerspace/hackerspace.by)

* Документация в Wiki: https://github.com/minsk-hackerspace/hackerspace.by/wiki
* SpaceAPI: https://hackerspace.by/spaceapi

### Разработка

Для сайта требуется [Ruby версии 2.5 и выше](https://www.ruby-lang.org/en/installation/), а также `bundler` (http://bundler.io/).

Тестовые пользователи: developer@hackerspace.by, developer2@hackerspace.by, admin@hackerspace.by, device@hackerspace.by пароль '111111'.


#### Запуск сайта локально на [http://localhost:3000/](http://localhost:3000/):

```
git clone https://github.com/minsk-hackerspace/hackerspace.by
cd hackerspace.by
cp config/database.example.yml config/database.yml
bundle install --without production
bundle exec rails db:setup
bundle exec rails server
```

`bundler` устанавливает библиотеки глобально, поэтому если не хочется мусорить, стоит посмотреть на RVM.

#### Запуск в контейнере с помощью docker-compose:
```
docker-compose build 
docker-compose up
```

#### Запуск в виртуалке под Vagrant:

```
git clone https://github.com/minsk-hackerspace/hackerspace.by
cd hackerspace.by
vagrant up
vagrant provision

# запуск сервера (который можно убить и опять запустить)
vagrant ssh -c "cd /vagrant_share && bundle exec rails server --binding=0.0.0.0"

```

#### Запуск тэстаў
```
rails db:test:prepare
rspec spec/
```
* калі структура базы не мянялася то каманду db:test:prepare можна не запускаць

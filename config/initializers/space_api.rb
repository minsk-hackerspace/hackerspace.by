#!/usr/bin/ruby
# encoding: utf-8

Rails.application.config.spaceapi_data = {
  space: "Minsk Hackerspace",
  logo: "http://hackerspace.by/images/default.png",
  url: "http://hackerspace.by",
  location: {
    address: "Basement near the entrance 3, Bjady 45, Minsk, Belarus",
    lon: 27.59749,
    lat: 53.94287,
  },
  contact: {
    facebook: "https://www.facebook.com/hs.minsk",
    irc: "irc://irc.bynets.org/#hackerspace",
    ml: "hackerspace-minsk@googlegroups.com",
  },
  issue_report_channels: [:ml],
  projects: [
    "http://hackerspace.by/projects/",
    "https://github.com/minsk-hackerspace/",
  ],
}

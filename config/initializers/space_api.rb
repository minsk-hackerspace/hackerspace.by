#!/usr/bin/ruby
# encoding: utf-8

Rails.application.config.spaceapi_data = {
  space: "Minsk Hackerspace",
  logo: "https://hackerspace.by/images/default.png",
  url: "https://hackerspace.by",
  location: {
    address: "Basement near the entrance 3, vul. Biady 45, Minsk, Belarus",
    lon: 27.59749,
    lat: 53.94287,
  },
  contact: {
    facebook: "https://www.facebook.com/hs.minsk",
    irc: "irc://irc.bynets.org/#hackerspace",
    ml: "hackerspace-minsk@googlegroups.com",
    email: "info@hackerspace.by",
  },
  issue_report_channels: [:ml, :email],
  projects: [
    "https://hackerspace.by/projects/",
    "https://github.com/minsk-hackerspace/",
  ],
}

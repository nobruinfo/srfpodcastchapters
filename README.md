# srfpodcastchapters

As stated in the live stream of **SRF Digital** March 12 2021:
https://www.srf.ch/audio/digital-podcast/ein-jpeg-fuer-69-millionen?id=11948464

This script allows downloading SRF audio podcasts from http://podcasts.srf.ch/digital_plus_mpx.xml
Recently the there provided files changed from m4a to mp3 no longer providing chapter meta data.

However, the chapters are still available in the podcast's xml structure, namely in the `description`
tag. This script downloads a given number of the most recent casts and converts them back if the
given format is mp3.

Progess mainly community driven. Let's see whether SRF audience reacts on it.

## prerequisites

You need to add certain tools to your folder structure and then modify path references within the
script:
- Optional: ~~[Nircmd](https://www.nirsoft.net/utils/nircmd.html), scroll all the way down to find the
  download there. This only makes the command line window bigger.~~
  This has been removed on July 3 2021.
- [FFMpeg](https://github.com/BtbN/FFmpeg-Builds/releases) or from another maintainer. If not sure
  on what type of graphics card you have simply use a link with a short name without "vulkan" or so.
  FFMpeg makes the conversion and allows chapter meta tags within the m4a file.
- [Mediainfo](https://mediaarea.net/de/MediaInfo/Download) is used to determine the total playtime
  of the downloaded MP3. This is then used as the endtime for the last chapter.
- [youtube-dl](https://youtube-dl.org/) has many uses. Here we have it as a podcast downloader.
  Options in the script are set to:
  - `--max-downloads 10` only the last 10 broadcasts. You may want to alter this number for your
    own comfort and the one of your device's storage.
  - `--download-archive archiv.ini` makes sure already downloaded episodes are not loaded again at
    later runs of the script.
  - `--dateafter 20200505` prevents the download of older episodes, in this case not before May 5th
    2020.
Rest of paths and options are not used/not relevant for the use. They will be removed after conclusion
of testing.

## changelog

**July 3 2021** Removed resizing the console window (nircmd and powershell lines) since this script
is mainly called by a wrapper doing such stuff.

**March 14 2021** In this version a fix had to ensure lines of the pod description begins with an
opening bracket. Before additional texts such as links to this site here lead to generation of fake
chapters. One could say a trap of its own success.

Many lines of the initial script were deleted since they were left from a template script of a
completely different origin.

**March 10 2021** Initial draft

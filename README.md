# srfpodcastchapters

This script allows downloading SRF audio podcasts from http://podcasts.srf.ch/digital_plus_mpx.xml
Recently the there provided files changed from m4a to mp3 no longer providing chapter meta data.

However, the chapters are still available in the podcast's xml structure, namely in the `description`
tag. This script downloads a given number of the most recent casts and converts them back if the
given format is mp3.

>>>
Please note this script is still unfinished business
>>>

Progess mainly community driven. Let's see whether SRF audience reacts on it.

## prerequisites

You need to add certain tools to your folder structure and then modify path references within the
script:
- Optional: [Nircmd](https://www.nirsoft.net/utils/nircmd.html), scroll all the way down to find the
  download there. This only makes the command line window bigger.
- [FFMpeg](https://github.com/BtbN/FFmpeg-Builds/releases) or from another maintainer. If not sure
  on what type of graphics card you have simply use a link with a short name without "vulkan" or so.
  FFMpeg makes the conversion and allows chapter meta tags within the m4a file.
- [youtube-dl](https://youtube-dl.org/) has many uses. Here we have it as a podcast downloader.
  Options in the script are set to:
  - `--max-downloads 100` only the last 100 broadcasts. You may want to decrease this number,
    especially for first runs of the script.
  - `--download-archive archiv.ini` makes sure already downloaded episodes are not loaded again at
    later runs of the script.
  - `--dateafter 20200505` prevents the download of older episodes, in this case not before May 5th
    2020.
Rest of paths and options are not used/not relevant for the use. They will be removed after conclusion
of testing.
